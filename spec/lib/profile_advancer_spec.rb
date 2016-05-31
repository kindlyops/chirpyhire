require 'rails_helper'

RSpec.describe ProfileAdvancer do
  include RSpec::Rails::Matchers

  let(:candidate) { create(:candidate) }
  let(:profile) { create(:profile, organization: candidate.organization) }
  let(:user) { candidate.user }

  describe ".call" do
    context "with an undetermined or stale profile features" do
      before(:each) do
        profile.features << create(:profile_feature)
      end

      it "creates an inquiry of the next candidate feature" do
        expect {
          ProfileAdvancer.call(candidate, profile)
        }.to change{user.inquiries.count}.by(1)
      end

      it "creates a message" do
        expect {
          ProfileAdvancer.call(candidate, profile)
        }.to change{user.messages.count}.by(1)
      end
    end

    context "with all profile features present" do
      it "creates an AutomatonJob for the screen event" do
        expect{
          ProfileAdvancer.call(candidate, profile)
        }.to have_enqueued_job(AutomatonJob).with(user, "screen")
      end

      it "creates a review task for the candidate's user" do
        expect{
          ProfileAdvancer.call(candidate, profile)
        }.to change{user.tasks.where(taskable: candidate).count}.by(1)
      end
    end
  end
end
