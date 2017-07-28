require 'rails_helper'

RSpec.describe Importer do
  let(:organization) { import.account.organization }

  subject { Importer.new(import) }

  describe '#call' do
    context 'single row' do
      context 'with ID column' do
        context 'and an id is present in the row' do
          let(:import) { create(:import, :id_column_id_present) }

          context 'and the id exists for a contact on the organization team' do
            let!(:contact) { create(:contact, id: 143132, organization: organization) }

            it 'updates that contact' do
              expect {
                subject.call
              }.to change { contact.reload.updated_at }
            end
          end

          context 'and the id does not exist for a contact on the organization team' do
            context 'phone number column is present' do
              context 'and it is a valid phone number' do
                let(:import) { create(:import, :id_column_id_present_valid_phone_number) }

                it 'creates a new contact' do
                  expect {
                    subject.call
                  }.to change { organization.reload.contacts.count }.by(1)
                end
              end

              context 'and it is an invalid phone number' do
                let(:import) { create(:import, :id_column_id_present_invalid_phone_number) }

                it 'creates an invalid phone number import error' do
                  expect {
                    subject.call
                  }.to change { import.reload.errors.invalid_phone_number.count }.by(1)
                end
              end

              context 'and the phone number is missing' do
                let(:import) { create(:import, :id_column_id_present_missing_phone_number) }

                it 'creates an phone_number_blank import error' do
                  expect {
                    subject.call
                  }.to change { import.reload.errors.phone_number_blank.count }.by(1)
                end
              end
            end

            context 'phone number column is not present' do
              it 'creates an phone_number_blank import error' do
                expect {
                  subject.call
                }.to change { import.reload.errors.phone_number_blank.count }.by(1)
              end
            end
          end
        end

        context 'and an id is not present in the row' do
          context 'with phone number column' do
            context 'and the phone number is valid' do
              let(:import) { create(:import, :id_column_id_missing_valid_phone_number) }

              context 'and the phone number is not tied to an organization contact' do
                it 'creates a new contact' do
                  expect {
                    subject.call
                  }.to change { organization.reload.contacts.count }.by(1)
                end
              end

              context 'and the phone number is tied to an organization contact' do
                let(:person) { create(:person, phone_number: '+14041234567') }
                let!(:contact) { create(:contact, person: person, organization: organization) }

                it 'updates the contact' do
                  expect {
                    subject.call
                  }.to change { contact.reload.updated_at }
                end
              end
            end

            context 'and the phone number is invalid' do
              let(:import) { create(:import, :id_column_id_missing_invalid_phone_number) }

              it 'creates an invalid phone number import error' do
                expect {
                  subject.call
                }.to change { import.reload.errors.invalid_phone_number.count }.by(1)
              end
            end

            context 'and the phone number is missing' do
              let(:import) { create(:import, :id_column_id_missing_phone_number_missing) }

              it 'creates a phone_number_blank import error' do
                expect {
                  subject.call
                }.to change { import.reload.errors.phone_number_blank.count }.by(1)
              end
            end
          end
        end
      end

      context 'without ID column' do
        context 'with phone number column' do
          context 'valid phone number' do
            let(:import) { create(:import, :no_id_column_valid_phone_number) }

            context 'tied to existing organization contact' do
              let(:person) { create(:person, phone_number: '+14041234567') }
              let!(:contact) { create(:contact, person: person, organization: organization) }
              
              it 'updates the existing contact' do
                expect {
                  subject.call
                }.to change { contact.reload.updated_at }
              end
            end

            context 'not tied to existing organization contact' do
              it 'creates a new contact' do
                expect {
                  subject.call
                }.to change { organization.reload.contacts.count }.by(1)
              end
            end
          end

          context 'invalid phone number' do
            let(:import) { create(:import, :no_id_column_invalid_phone_number) }

            it 'creates an invalid phone number import error' do
              expect {
                subject.call
              }.to change { import.reload.errors.invalid_phone_number.count }.by(1)
            end
          end

          context 'phone_number_blank' do
            let(:import) { create(:import, :no_id_column_missing_phone_number) }

            it 'creates a phone_number_blank import error' do
              expect {
                subject.call
              }.to change { import.reload.errors.phone_number_blank.count }.by(1)
            end
          end
        end
      end
    end

    context 'two valid rows' do
      context 'that are both valid' do
        context 'and new' do
          let(:import) { create(:import, :multiple) }

          it 'creates two contacts' do
            expect {
              subject.call
            }.to change { organization.reload.contacts.count }.by(2)
          end
        end
      end
    end
  end
end
