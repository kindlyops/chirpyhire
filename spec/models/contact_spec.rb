require 'rails_helper'

RSpec.describe Contact do
  describe '#nickname' do
    context 'with a name' do
      subject { create(:contact, name: 'Foo') }

      it 'is not present' do
        expect(subject.nickname).not_to be_present
      end
    end

    context 'without a name' do
      subject { create(:contact) }

      it 'is present' do
        expect(subject.nickname).to be_present
      end
    end
  end

  describe '.tag_filter' do
    context 'two tags' do
      let!(:contact) { create(:contact) }
      let(:organization) { contact.organization }
      let(:tag) { create(:tag) }
      let(:tag2) { create(:tag) }

      context 'contact has the two tags' do
        before do
          contact.tags << tag
          contact.tags << tag2
        end

        it 'has the contact with two tags' do
          expect(organization.contacts.tag_filter([tag.id, tag2.id])).to include(contact)
        end
      end

      context 'has only one tag' do
        before do
          contact.tags << tag
        end

        it 'does not include the contact' do
          expect(organization.contacts.tag_filter([tag.id, tag2.id])).not_to include(contact)
        end
      end

      context 'has only no tags' do
        it 'does not include the contact' do
          expect(organization.contacts.tag_filter([tag.id, tag2.id])).not_to include(contact)
        end
      end
    end
  end

  describe '.campaigns_filter' do
    context 'two campaigns' do
      let!(:contact) { create(:contact) }
      let(:organization) { contact.organization }
      let(:campaign) { create(:manual_message) }
      let(:campaign2) { create(:manual_message) }

      context 'contact has the two campaigns' do
        before do
          contact.manual_message_participants.create(manual_message: campaign)
          contact.manual_message_participants.create(manual_message: campaign2)
        end

        it 'has the contact with two campaigns' do
          expect(organization.contacts.campaigns_filter([campaign.id, campaign2.id])).to include(contact)
        end
      end

      context 'has only one campaign' do
        before do
          contact.manual_message_participants.create(manual_message: campaign)
        end

        it 'does not include the contact' do
          expect(organization.contacts.campaigns_filter([campaign.id, campaign2.id])).not_to include(contact)
        end
      end

      context 'has only no campaigns' do
        it 'does not include the contact' do
          expect(organization.contacts.campaigns_filter([campaign.id, campaign2.id])).not_to include(contact)
        end
      end
    end
  end

  describe '.messages_filter' do
    context 'contacts' do
      let!(:contact_1) { create(:contact) }
      let!(:contact_2) { create(:contact) }
      let!(:contact_3) { create(:contact) }

      context 'one with a conversation and a message' do
        before do
          create(:message, conversation: create(:conversation, contact: contact_1))
        end

        context 'one with a conversation and two messages' do
          let!(:contact_4) { create(:contact) }
          before do
            conversation = create(:conversation, contact: contact_4)
            create(:message, conversation: conversation)
            create(:message, conversation: conversation)
          end

          context '2' do
            it 'is just the one' do
              expect(Contact.messages_filter(2)).to contain_exactly(contact_4)
            end
          end
        end

        context 'and one with a conversation' do
          before do
            create(:conversation, contact: contact_2)
          end

          context 'and one without a conversation' do
            context '0' do
              it 'is just two' do
                expect(Contact.messages_filter(0)).to contain_exactly(contact_2, contact_3)
              end
            end

            context '1' do
              it 'is just one' do
                expect(Contact.messages_filter(1)).to contain_exactly(contact_1)
              end
            end

            context '2' do
              it 'is none' do
                expect(Contact.messages_filter(2)).to match_array([])
              end
            end
          end
        end
      end
    end
  end

  describe '.zipcode_filter' do
    subject { create(:contact, '30341'.to_sym) }

    context '"DeKalb" county searched for' do
      describe 'with "Dekalb" county in database' do
        it 'is case insensitive' do
          expect(Contact.zipcode_filter(county_name: 'DeKalb')).to include(subject)
        end
      end
    end
  end
end
