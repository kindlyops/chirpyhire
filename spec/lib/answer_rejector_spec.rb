require 'rails_helper'

RSpec.describe AnswerRejector do
  let(:candidate) { create(:candidate) }
  let(:survey) { candidate.organization.create_survey }
  let(:answer_rejector) { AnswerRejector.new(candidate, question) }

  describe "#call" do
    context "without geofence" do
      let(:question) { create(:address_question, survey: survey) }

      it "returns false" do
        expect(answer_rejector.call).to eq(false)
      end
    end

    context "with geofence" do
      let(:question) { create(:address_question, survey: survey) }
      let(:latitude) { 12.345678 }
      let(:longitude) { 87.654321 }
      let!(:address_question_option) { create(:address_question_option, latitude: latitude, longitude: longitude, question: question) }
      let(:candidate) { create(:candidate, :with_address) }

      context "and the candidates coordinates are within the geofence" do
        before(:each) do
          existing_properties = candidate.address_feature.properties
          candidate.address_feature.update(properties: existing_properties.merge(latitude: latitude, longitude: longitude))
        end

        it "returns false" do
          expect(answer_rejector.call).to eq(false)
        end
      end

      context "and the candidates coordinates are outside the geofence" do
        before(:each) do
          existing_properties = candidate.address_feature.properties
          candidate.address_feature.update(properties: existing_properties.merge(latitude: 38.918138, longitude: -77.241273))
        end

        it "is true" do
          expect(answer_rejector.call).to eq(true)
        end
      end
    end
  end
end
