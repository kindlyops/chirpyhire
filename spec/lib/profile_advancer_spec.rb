require 'rails_helper'

RSpec.describe ProfileAdvancer do
  include RSpec::Rails::Matchers

  let(:candidate) { create(:candidate) }
  let(:candidate_persona) { candidate.candidate_persona }
  let(:user) { candidate.user }

  describe ".call" do
    context "with an undetermined or stale profile feature" do
      before(:each) do
        create(:persona_feature, candidate_persona: candidate_persona)
      end

      it "creates an inquiry of the next candidate feature" do
        expect {
          ProfileAdvancer.call(user.candidate)
        }.to change{user.inquiries.count}.by(1)
      end

      it "creates a message" do
        expect {
          ProfileAdvancer.call(user.candidate)
        }.to change{Message.count}.by(1)
      end
    end

    context "with all profile features present" do
      it "creates an AutomatonJob for the screen event" do
        expect{
          ProfileAdvancer.call(user.candidate)
        }.to have_enqueued_job(AutomatonJob).with(user, "screen")
      end

      it "creates an outstanding screen activity for the candidate's user" do
        expect{
          ProfileAdvancer.call(user.candidate)
        }.to change{user.outstanding_activities.where(trackable: candidate).count}.by(1)
      end

      it "marks the candidate as screened" do
        expect{
          ProfileAdvancer.call(user.candidate)
        }.to change{candidate.screened?}.from(false).to(true)
      end
    end
  end
end
