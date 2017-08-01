require 'rails_helper'

RSpec.describe Contact do
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
