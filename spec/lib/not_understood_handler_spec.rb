require 'rails_helper'

RSpec.describe NotUnderstoodHandler do
  describe '.notify' do
    let(:organization) { create(:organization) }
    let!(:survey) { create(:survey, organization: organization) }
    let(:question) { create(:question, survey: survey) }
    let(:user) { create(:user, organization: organization) }
    context 'with a not_understood_count beneath the threshold' do
      let(:inquiry) { create(:inquiry, question: question) }
      it 'increments not_understood_count' do
        expect {
          NotUnderstoodHandler.notify(user, inquiry)
        }.to change { inquiry.not_understood_count }.by(1)
      end
      it 'sends the user the template' do
        expect {
          NotUnderstoodHandler.notify(user, inquiry)
        }.to change { user.messages.count }.by(1)
      end
      it 'marks the user as having unread messages' do
        expect {
          NotUnderstoodHandler.notify(user, inquiry)
        }.to change { user.has_unread_messages }.to(true)
      end
    end

    context 'with a not_understood_count above the threshold' do
      let(:inquiry) {
        create(
          :inquiry,
          question: question,
          not_understood_count: NotUnderstoodHandler::THRESHOLD
        )
      }
      it 'does not increment not_understood_count' do
        expect {
          NotUnderstoodHandler.notify(user, inquiry)
        }.not_to change { inquiry.not_understood_count }
      end

      it 'does not send the user the template' do
        expect {
          NotUnderstoodHandler.notify(user, inquiry)
        }.not_to change { user.messages.count }
      end
    end
  end
end
