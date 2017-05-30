require 'rails_helper'

RSpec.describe Migrator::TeamMigrator do
  let(:to_organization) { create(:organization) }
  let(:from_organization) { create(:organization, :team_with_phone_number_and_recruiting_ad) }
  let(:team) { from_organization.teams.first }
  let!(:phone_number) { team.phone_number }

  let(:from_account_a) { create(:account, :inbox, organization: from_organization) }
  let(:from_account_b) { create(:account, :inbox, organization: from_organization) }
  let(:from_account_c) { create(:account, :inbox, organization: from_organization) }

  let(:to_account_a) { create(:account, :inbox, organization: to_organization) }
  let(:to_account_b) { create(:account, :inbox, organization: to_organization) }
  let(:to_account_c) { create(:account, :inbox, organization: to_organization) }

  let(:organizations) do
    { from: from_organization, to: to_organization }
  end

  let(:accounts) do
    [
      { from: from_account_a, to: to_account_a },
      { from: from_account_b, to: to_account_b },
      { from: from_account_c, to: to_account_c }
    ]
  end

  let!(:options) do
    {
      organizations: organizations,
      accounts: accounts,
      team: team
    }
  end

  subject { Migrator::TeamMigrator.new(options) }

  describe '#migrate' do
    it 'updates the old team phone number' do
      subject.migrate
      expect(team.phone_number).to eq("MIGRATED:#{phone_number}")
    end

    it 'creates a new team' do
      expect {
        subject.migrate
      }.to change { Team.count }.by(1)
    end

    it 'has the old team phone number' do
      subject.migrate
      expect(Team.last.phone_number).to eq(phone_number)
    end

    it 'is tied to the new organization' do
      subject.migrate
      expect(Team.last.organization).to eq(to_organization)
    end

    it 'has the old team name' do
      subject.migrate
      expect(Team.last.name).to eq(team.name)
    end

    it 'creates a new recruiting ad' do
      expect {
        subject.migrate
      }.to change { RecruitingAd.count }.by(1)
    end

    it 'has the old ad body' do
      subject.migrate
      expect(RecruitingAd.last.body).to eq(team.recruiting_ad.body)
    end

    it 'is tied to the new organization' do
      subject.migrate
      expect(RecruitingAd.last.organization).to eq(to_organization)
    end

    it 'joins the accounts to the new team' do
      subject.migrate

      accounts.map { |a| a[:to] }.each do |account|
        expect(Team.last.accounts).to include(account)
      end
    end

    context 'with contact' do
      let!(:contact) { create(:contact, team: team) }

      context 'with conversations' do
        before do
          IceBreaker.call(contact)
        end

        it 'creates a new contact' do
          expect {
            subject.migrate
          }.to change { Contact.count }.by(1)
        end

        it 'is tied to the old person' do
          subject.migrate
          expect(Contact.last.person).to eq(contact.person)
        end

        it 'is tied to the new team' do
          subject.migrate
          expect(Contact.last.team).to eq(Team.last)
        end

        it 'creates a new conversation for each account' do
          expect {
            subject.migrate
          }.to change { InboxConversation.count }.by(accounts.count)
        end

        context 'with message' do
          context 'inbound message' do
            let!(:message) { create(:message, sender: contact.person, conversation: contact.conversation) }
            let!(:sid) { message.sid }

            it 'creates a new message' do
              expect {
                subject.migrate
              }.to change { Message.count }.by(1)
            end

            it 'is tied to the same sender' do
              subject.migrate
              expect(Message.last.sender).to eq(contact.person)
            end

            it 'has the same sid as the old message' do
              subject.migrate
              expect(Message.last.sid).to eq(sid)
            end

            context 'with read receipt' do
              let!(:conversation) { contact.inbox_conversations.find_by(inbox: from_account_a.inbox) }
              let!(:read_receipt) { create(:read_receipt, message: message, inbox_conversation: conversation, read_at: rand(10.days).seconds.ago) }

              it 'creates a new read receipt' do
                expect {
                  subject.migrate
                }.to change { ReadReceipt.count }.by(1)
              end

              it 'is tied to the new message' do
                subject.migrate
                expect(Message.last).to eq(ReadReceipt.last.message)
              end

              it 'has the same read_at as the old receipt' do
                subject.migrate
                expect(ReadReceipt.last.read_at).to eq(read_receipt.read_at)
              end

              it 'is tied to the new conversation' do
                subject.migrate
                new_contact = to_organization.contacts.find_by(person: contact.person)
                new_conversation = to_account_a.inbox_conversations.find_by(conversation: new_contact.conversation)

                expect(ReadReceipt.last.inbox_conversation).to eq(new_conversation)
              end
            end
          end

          context 'outbound chirpy automated message' do
            let!(:message) { create(:message, sender: Chirpy.person, recipient: contact.person, conversation: contact.conversation) }
            let!(:sid) { message.sid }

            it 'creates a new message' do
              expect {
                subject.migrate
              }.to change { Message.count }.by(1)
            end

            it 'is tied to the same sender' do
              subject.migrate
              expect(Message.last.sender).to eq(Chirpy.person)
            end

            it 'is tied to the same recipient' do
              subject.migrate
              expect(Message.last.recipient).to eq(contact.person)
            end

            it 'has the same sid as the old message' do
              subject.migrate
              expect(Message.last.sid).to eq(sid)
            end
          end

          context 'outbound account message' do
            let!(:message) { create(:message, sender: from_account_a.person, recipient: contact.person, conversation: contact.conversation) }
            let!(:sid) { message.sid }

            it 'creates a new message' do
              expect {
                subject.migrate
              }.to change { Message.count }.by(1)
            end

            it 'is tied to the same sender' do
              subject.migrate
              expect(Message.last.sender).to eq(to_account_a.person)
            end

            it 'is tied to the same recipient' do
              subject.migrate
              expect(Message.last.recipient).to eq(contact.person)
            end

            it 'has the same sid as the old message' do
              subject.migrate
              expect(Message.last.sid).to eq(sid)
            end
          end
        end
      end

      context 'with note' do
        let!(:note) { create(:note, contact: contact, account: from_account_a) }

        it 'creates a new note' do
          expect {
            subject.migrate
          }.to change { Note.count }.by(1)
        end

        it 'is tied to the new contact' do
          subject.migrate
          new_contact = to_organization.contacts.find_by(person: contact.person)
          expect(Note.last.contact).to eq(new_contact)
        end

        it 'is tied to the new account' do
          subject.migrate
          expect(Note.last.account).to eq(to_account_a)
        end

        it 'has the same body as the old note' do
          subject.migrate
          expect(Note.last.body).to eq(note.body)
        end
      end
    end
  end
end
