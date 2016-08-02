require 'rails_helper'

RSpec.describe AnswerRejector do
  let(:candidate) { create(:candidate) }
  let(:survey) { candidate.organization.create_survey }
  let(:answer_rejector) { AnswerRejector.new(candidate, question) }

  describe "#call" do
    context "without geofence" do
      let(:question) { create(:question, survey: survey) }

      it "returns false" do
        expect(answer_rejector.call).to eq(false)
      end
    end

    context "with geofence" do
      let(:question) { create(:question, :with_geofence, survey: survey) }
      let(:candidate) { create(:candidate, :with_address) }

      context "and the candidates coordinates are within the geofence" do
        before(:each) do
          existing_properties = candidate.address_feature.properties
          candidate.address_feature.update(properties: existing_properties.merge(latitude: 38.030458, longitude: -78.481070))
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
