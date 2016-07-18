require 'rails_helper'

RSpec.describe ProfileAdvancer do
  include RSpec::Rails::Matchers

  let(:user) { create(:user, :with_candidate) }
  let(:candidate_persona) { candidate.organization.candidate_persona }
  let(:candidate) { user.candidate }

  describe ".call" do
    context "with an undetermined or stale profile feature" do
      before(:each) do
        create(:persona_feature, candidate_persona: candidate_persona)
      end

      context "when the user is unsubscribed" do
        before(:each) do
          user.update(subscribed: false)
        end

        it "does not create an inquiry of the next candidate feature" do
          expect {
            ProfileAdvancer.call(user)
          }.not_to change{user.inquiries.count}
        end

        it "does not create a message" do
          expect {
            ProfileAdvancer.call(user)
          }.not_to change{Message.count}
        end

        it "does not create an AutomatonJob for the screen event" do
          expect{
            ProfileAdvancer.call(user)
          }.not_to have_enqueued_job(AutomatonJob)
        end

        it "does not change the candidate's status to Screened" do
          expect{
            ProfileAdvancer.call(user)
          }.not_to change{candidate.status}
        end
      end

      context "when the user is subscribed" do
        before(:each) do
          user.update(subscribed: true)
        end

        it "creates an inquiry of the next candidate feature" do
          expect {
            ProfileAdvancer.call(user)
          }.to change{user.inquiries.count}.by(1)
        end

        it "creates a message" do
          expect {
            ProfileAdvancer.call(user)
          }.to change{Message.count}.by(1)
        end
      end
    end

    context "with all profile features present and user is subscribed" do
      before(:each) do
        user.update(subscribed: true)
      end

      it "creates an AutomatonJob for the screen event" do
        expect{
          ProfileAdvancer.call(user)
        }.to have_enqueued_job(AutomatonJob).with(user, "screen")
      end

      it "changes the candidate's status to Screened" do
        expect{
          ProfileAdvancer.call(user)
        }.to change{candidate.status}.from("Potential").to("Screened")
      end
    end
  end
end
