require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#cannot_receive_messages?' do
    let!(:organization) { user.organization }
    let!(:subscription) { create(:subscription, organization: organization) }

    it 'is false' do
      expect(user.cannot_receive_messages?).to eq(false)
    end

    context 'when the trial is finished' do
      before(:each) do
        subscription.update(state: 'trialing')
        subscription.update(trial_message_limit: 1)
        create_list(:message, 2, user: user)
      end

      it 'is true' do
        expect(user.cannot_receive_messages?).to eq(true)
      end
    end

    context 'when the monthly message limit is reached' do
      before(:each) do
        subscription.update(state: 'active', quantity: 1)
        Plan.messages_per_quantity = 1
        create(:message, user: user)
      end

      it 'is true' do
        expect(user.cannot_receive_messages?).to eq(true)
      end
    end

    context 'when the phone number is blank' do
      before(:each) do
        user.update(phone_number: nil)
      end

      it 'is true' do
        expect(user.cannot_receive_messages?).to eq(true)
      end
    end
  end

  describe '#receive_message' do
    it 'creates a message for the user' do
      expect do
        user.receive_message(body: 'Foo')
      end.to change { user.messages.count }.by(1)
    end

    it 'sends a message' do
      expect do
        user.receive_message(body: 'Foo')
      end.to change { FakeMessaging.messages.count }.by(1)
    end

    context 'with prior messages' do
      let!(:message) { create(:message, user: user, created_at: Date.yesterday) }
      let!(:most_recent_message) { create(:message, user: user) }

      it 'sets the new message as the child on the most recent message' do
        message = user.receive_message(body: 'Foo')
        expect(user.messages.by_recency.second.child).to eq(message)
      end
    end
  end

  describe '#last_answer' do
    context 'with multiple answers' do
      let(:first_message) { create(:message, :with_image, user: user) }
      let!(:first_answer) { create(:answer, :to_document_question, message: first_message, created_at: 7.days.ago) }
      let(:second_message) { create(:message, :with_image, user: user) }
      let!(:second_answer) { create(:answer, :to_document_question, message: second_message) }

      it 'is the most recently created answer' do
        expect(user.last_answer).to eq(second_answer)
      end
    end
  end

  describe '#unsubscribed?' do
    context 'with a subscription to the organization' do
      it 'is false' do
        user.update(subscribed: true)
        expect(user.unsubscribed?).to eq(false)
      end
    end

    context 'without a subscription to the organization' do
      it 'is true' do
        user.update(subscribed: false)
        expect(user.unsubscribed?).to eq(true)
      end
    end
  end
end
