require 'rails_helper'

RSpec.feature 'Conversations', type: :feature, js: true do
  let(:account) { create(:account, :with_subscription) }

  before do
    login_as(account, scope: :account)
  end

  context 'with conversations' do
    let(:user) { create(:user, organization: account.organization) }
    let!(:conversation) { create(:message, body: 'Conversation Test Body', user: user) }

    it 'allows you to view a specific conversation' do
      visit messages_path
      click_link("conversation-#{conversation.id}")
      expect(page).to have_text('Send')
      expect(page).to have_text(user.phone_number.phony_formatted)
      expect(page).to have_text(conversation.body)
    end

    context 'with an image message as the conversation' do
      let!(:conversation) { create(:message, :with_image, user: user) }
      it 'shows Image message in lieu of a picture' do
        visit messages_path
        expect(page).to have_text('Image message')
      end
    end

    context 'more than one page of conversations' do
      let(:users) { create_list(:user, 16, organization: account.organization) }
      let!(:conversations) do
        users.each_with_index do |user, _index|
          create(:message, body: Faker::Lorem.sentence, user: user)
        end
      end

      it 'allows you to page to the next group of conversations' do
        visit messages_path

        users[0..7].each do |user|
          expect(page).not_to have_text(user.phone_number.phony_formatted)
          expect(page).not_to have_text(user.messages.last.body)
        end

        click_link('2')

        users[0..7].each do |user|
          expect(page).to have_text(user.phone_number.phony_formatted)
          expect(page).to have_text(user.messages.last.body)
        end
      end

      context 'with unread messages' do
        before(:each) do
          users.first.update(has_unread_messages: true)
        end

        it 'allows you to page to the next group of conversations' do
          visit messages_path

          expect(page).to have_text(users.first.phone_number.phony_formatted)
          expect(page).to have_text(users.first.messages.last.body)

          click_link('2')

          expect(page).not_to have_text(users.first.phone_number.phony_formatted)
          expect(page).not_to have_text(users.first.messages.last.body)
        end
      end
    end
  end
end
