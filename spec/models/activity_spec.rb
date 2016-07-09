require 'rails_helper'

RSpec.describe Activity do

  describe ".outstanding" do
    let!(:inquiry) { create(:inquiry) }

    context "with outstanding activities" do
      let(:candidates) { create_list(:candidate, 2) }
      let!(:outstanding_activities) do
        candidates.map do |candidate|
          candidate.create_activity :screen, outstanding: true, owner: candidate.user
        end
      end

      it "is the outstanding activities" do
        expect(Activity.outstanding).to match_array(outstanding_activities)
      end
    end

    it "is empty" do
      expect(Activity.outstanding).to eq([])
    end
  end

  describe "#has_chirp?" do
    let(:activity) { create(:chirp).activities.last }

    context "when the trackable type is Chirp" do
      it "is true" do
        expect(activity.has_chirp?).to eq(true)
      end
    end

    context "when the trackable type is not Chirp" do
      let(:candidate) { create(:candidate) }
      let(:activity) do
        candidate.create_activity :screen, owner: candidate.user
      end

      it "is false" do
        expect(activity.has_chirp?).to eq(false)
      end
    end
  end
end
