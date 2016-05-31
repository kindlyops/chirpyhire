require 'rails_helper'

RSpec.describe ProfileJob do

  let(:candidate) { create(:candidate) }
  let(:profile) { create(:profile, organization: candidate.organization) }
  let(:user) { candidate.user }
  let(:trigger) { create(:trigger, event: :screen) }

  describe "#perform" do
    context "with an undetermined or stale profile features" do
      before(:each) do
        profile.features << create(:profile_feature)
      end

      it "creates an inquiry of the next candidate feature" do
        expect {
          ProfileJob.perform_now(candidate, profile)
        }.to change{user.inquiries.count}.by(1)
      end

      it "creates a message" do
        expect {
          ProfileJob.perform_now(candidate, profile)
        }.to change{user.messages.count}.by(1)
      end
    end

    context "with all profile features present" do
      it "creates an AutomatonJob for the screen event" do
        expect{
          ProfileJob.perform_now(candidate, profile)
        }.to have_enqueued_job(AutomatonJob).with(user, trigger)
      end

      it "creates a review task for the candidate's user" do
        expect{
          ProfileJob.perform_now(candidate, profile)
        }.to change{user.tasks.where(category: "review").count}.by(1)
      end
    end
  end
end
