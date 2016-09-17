# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Messages', type: :feature, js: true do
  let(:account) { create(:account, :with_subscription) }

  before do
    login_as(account, scope: :account)
  end

  context 'with messages' do
    let(:user) { create(:user, organization: account.organization) }
    let!(:message) { create(:message, body: 'Message Test Body', user: user) }

    it 'allows you to view the message' do
      visit user_messages_path(user)
      expect(page).to have_text('Send')
      expect(page).to have_text(user.phone_number.phony_formatted)
      expect(page).to have_text(message.body)
    end

    context 'sending messages' do
      let(:new_message) { 'This is a new message to send' }

      context 'subscribed' do
        before do
          user.update(subscribed: true)
        end

        it 'allows you to send a new message' do
          visit user_messages_path(user)
          fill_in 'message_body', with: new_message
          click_button 'Send'
          expect(find_field('message_body').text).to eq('')
          expect(page).to have_text(new_message)
        end
      end

      context 'unsubscribed' do
        it 'displays a helpful error message' do
          visit user_messages_path(user)
          fill_in 'message_body', with: new_message
          click_button 'Send'
          expect(find_field('message_body').text).to eq('')
          expect(page).to have_text("Unfortunately they are unsubscribed! You can't text unsubscribed candidates using Chirpyhire.")
        end
      end
    end

    context 'with image message' do
      let!(:message) { create(:message, :with_image, user: user) }

      it 'allows you to view the image' do
        visit user_messages_path(user)
        expect(page).to have_selector("img[src^='#{MediaInstance::URI_BASE}']")
      end
    end

    context 'more than one page of messages' do
      let!(:messages) do
        Array.new(20) { |i| create(:message, body: "Message #{i}", user: user) }
      end

      it 'allows you to page to the next group of messages' do
        visit user_messages_path(user)

        messages[12..19].each do |message|
          expect(page).to have_text(message.body)
        end

        messages[4..11].each do |message|
          expect(page).not_to have_text(message.body)
        end

        click_link('Load more messages')

        messages[4..19].each do |message|
          expect(page).to have_text(message.body)
        end
      end
    end
  end
end
