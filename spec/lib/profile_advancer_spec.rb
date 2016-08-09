require 'rails_helper'

RSpec.describe ProfileAdvancer do
  include RSpec::Rails::Matchers

  let(:user) { create(:user, :with_candidate) }
  let!(:survey) { create(:survey, organization: user.organization) }
  let(:candidate) { user.candidate }

  describe ".call" do
    context "when the user is unsubscribed" do
      before(:each) do
        user.update(subscribed: false)
      end

      it "does not create an inquiry of the next candidate feature" do
        expect {
          ProfileAdvancer.call(user)
        }.not_to change{user.inquiries.count}
      end

      it "does not create a notification" do
        expect {
          ProfileAdvancer.call(user)
        }.not_to change{user.notifications.count}
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

      it "does not change the candidate's status" do
        expect{
          ProfileAdvancer.call(user)
        }.not_to change{candidate.status}
      end
    end

    context "when the user is subscribed" do
      before(:each) do
        user.update(subscribed: true)
      end

      context "with an undetermined or stale profile feature" do
        before(:each) do
          create(:question, survey: survey)
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

        context "and the last answer was unacceptable" do
          before(:each) do
            allow_any_instance_of(ProfileAdvancer).to receive(:answer_rejected?).and_return(true)
          end
          let(:question) { create(:document_question, survey: survey) }
          let(:inquiry) { create(:inquiry, question: question) }
          let(:message) { create(:message, :with_image, user: user) }
          let!(:answer) { create(:answer, inquiry: inquiry, message: message) }

          context "with a template for the candidate persona" do
            it "does not create an inquiry of the next candidate feature" do
              expect {
                ProfileAdvancer.call(user)
              }.not_to change{user.inquiries.count}
            end

            it "creates a notification" do
              expect {
                ProfileAdvancer.call(user)
              }.to change{user.notifications.count}.by(1)
            end

            it "creates a message" do
              expect {
                ProfileAdvancer.call(user)
              }.to change{Message.count}.by(1)
            end

            it "changes the candidate's status to Bad Fit" do
              expect{
                ProfileAdvancer.call(user)
              }.to change{candidate.status}.from("Potential").to("Bad Fit")
            end
          end
        end
      end

      context "with all profile features present" do
        it "creates an AutomatonJob for the screen event" do
          expect{
            ProfileAdvancer.call(user)
          }.to have_enqueued_job(AutomatonJob).with(user, "screen")
        end

        it "changes the candidate's status to Qualified" do
          expect{
            ProfileAdvancer.call(user)
          }.to change{candidate.status}.from("Potential").to("Qualified")
        end
      end
    end
  end
end
