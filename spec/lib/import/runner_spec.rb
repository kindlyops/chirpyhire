require 'rails_helper'

RSpec.describe Import::Runner do
  let(:organization) { create(:organization, :stages, :team) }
  let(:account) { create(:account, organization: organization) }

  subject { Import::Runner.new(import) }

  describe '#call' do
    context 'iso-8859-1' do
      let(:import) { create(:import, :iso_8859_1, account: account) }

      it 'does not raise an error' do
        expect {
          subject.call
        }.not_to raise_error
      end
    end

    context 'illegal quoting' do
      let(:import) { create(:import, :illegal_quoting, account: account) }

      it 'does not raise an error' do
        expect {
          subject.call
        }.not_to raise_error
      end
    end

    context 'nil header' do
      let(:import) { create(:import, :nil_header, account: account) }

      it 'does not raise an error' do
        expect {
          subject.call
        }.not_to raise_error
      end
    end

    context 'single row' do
      context 'with ID column' do
        context 'and an id is present in the row' do
          context 'and the id exists for a contact on the organization team' do
            context 'and phone number is present' do
              let!(:contact) { create(:contact, id: 143_132, phone_number: '+14041234567', organization: organization) }

              context 'and valid' do
                let(:import) { create(:import, :id_column_id_present_valid_phone_number, account: account) }

                it 'updates that contact' do
                  expect {
                    subject.call
                  }.to change { contact.reload.updated_at }
                end

                it 'changes the import to complete' do
                  expect {
                    subject.call
                  }.to change { import.reload.status }.to('complete')
                end

                it 'creates an updated contacts import' do
                  expect {
                    subject.call
                  }.to change { import.reload.contacts_imports.updated.count }.by(1)
                end
              end

              context 'and invalid' do
                let(:import) { create(:import, :id_column_id_present_invalid_phone_number, account: account) }

                it 'creates an invalid phone number import error' do
                  expect {
                    subject.call
                  }.to change { import.reload.import_errors.invalid_phone_number.count }.by(1)
                end
              end

              context 'and missing' do
                let(:import) { create(:import, :id_column_id_present_missing_phone_number, account: account) }

                it 'creates an phone_number_blank import error' do
                  expect {
                    subject.call
                  }.to change { import.reload.import_errors.blank_phone_number.count }.by(1)
                end
              end
            end
          end

          context 'and the id does not exist for a contact on the organization team' do
            context 'phone number column is present' do
              context 'and it is a valid phone number' do
                let(:import) { create(:import, :id_column_id_present_valid_phone_number, account: account) }

                it 'creates a new subscribed contact' do
                  expect {
                    subject.call
                  }.to change { organization.reload.contacts.subscribed.count }.by(1)
                end

                it 'creates a created contacts import' do
                  expect {
                    subject.call
                  }.to change { import.reload.contacts_imports.created.count }.by(1)
                end
              end

              context 'and it is an invalid phone number' do
                let(:import) { create(:import, :id_column_id_present_invalid_phone_number, account: account) }

                it 'creates an invalid phone number import error' do
                  expect {
                    subject.call
                  }.to change { import.reload.import_errors.invalid_phone_number.count }.by(1)
                end
              end

              context 'and the phone number is missing' do
                let(:import) { create(:import, :id_column_id_present_missing_phone_number, account: account) }

                it 'creates an phone_number_blank import error' do
                  expect {
                    subject.call
                  }.to change { import.reload.import_errors.blank_phone_number.count }.by(1)
                end
              end
            end
          end
        end

        context 'and an id is not present in the row' do
          context 'with phone number column' do
            context 'and the phone number is valid' do
              let(:import) { create(:import, :id_column_id_missing_valid_phone_number, account: account) }

              context 'and the phone number is not tied to an organization contact' do
                it 'creates a new subscribed contact' do
                  expect {
                    subject.call
                  }.to change { organization.reload.contacts.subscribed.count }.by(1)
                end

                it 'creates a created contacts import' do
                  expect {
                    subject.call
                  }.to change { import.reload.contacts_imports.created.count }.by(1)
                end
              end

              context 'and the phone number is tied to an organization contact' do
                let!(:contact) { create(:contact, phone_number: '+14041234567', organization: organization) }

                it 'updates the contact' do
                  expect {
                    subject.call
                  }.to change { contact.reload.updated_at }
                end

                it 'creates an updated contacts import' do
                  expect {
                    subject.call
                  }.to change { import.reload.contacts_imports.updated.count }.by(1)
                end
              end
            end

            context 'and the phone number is invalid' do
              let(:import) { create(:import, :id_column_id_missing_invalid_phone_number, account: account) }

              it 'creates an invalid phone number import error' do
                expect {
                  subject.call
                }.to change { import.reload.import_errors.invalid_phone_number.count }.by(1)
              end
            end

            context 'and the phone number is missing' do
              let(:import) { create(:import, :id_column_id_missing_phone_number_missing, account: account) }

              it 'creates a phone_number_blank import error' do
                expect {
                  subject.call
                }.to change { import.reload.import_errors.blank_phone_number.count }.by(1)
              end
            end
          end
        end
      end

      context 'without ID column' do
        context 'with phone number column' do
          context 'valid phone number' do
            let(:import) { create(:import, :no_id_column_valid_phone_number, account: account) }

            context 'tied to existing organization contact' do
              let!(:contact) { create(:contact, phone_number: '+14041234567', organization: organization) }

              it 'updates the existing contact' do
                expect {
                  subject.call
                }.to change { contact.reload.updated_at }
              end

              it 'creates an updated contacts import' do
                expect {
                  subject.call
                }.to change { import.reload.contacts_imports.updated.count }.by(1)
              end

              context 'tag' do
                let(:tag) { create(:tag) }
                before do
                  import.tags << tag
                end

                context 'contact already has the tag' do
                  before do
                    contact.tags << tag
                  end

                  it 'is ok' do
                    expect {
                      subject.call
                    }.not_to raise_error
                  end
                end
              end

              context 'with email column' do
                context 'valid email address' do
                  let(:import) { create(:import, :no_id_column_valid_phone_number_valid_email, account: account) }

                  it 'updates the existing contact email' do
                    expect {
                      subject.call
                    }.to change { contact.reload.email }.from(nil)
                  end
                end

                context 'invalid email address' do
                  let(:import) { create(:import, :no_id_column_valid_phone_number_invalid_email, account: account) }

                  it 'updates the existing contact email' do
                    expect {
                      subject.call
                    }.to change { contact.reload.email }.from(nil)
                  end
                end

                context 'blank email address' do
                  let(:import) { create(:import, :no_id_column_valid_phone_number_blank_email, account: account) }

                  it 'does not update the existing contact email' do
                    expect {
                      subject.call
                    }.not_to change { contact.reload.email }
                  end
                end
              end
            end

            context 'not tied to existing organization contact' do
              it 'creates a new subscribed contact' do
                expect {
                  subject.call
                }.to change { organization.reload.contacts.subscribed.count }.by(1)
              end

              context 'with source' do
                let(:import) { create(:import, :no_id_column_valid_phone_number_source, account: account) }

                it 'sets the source on the new contact' do
                  subject.call
                  expect(organization.reload.contacts.last.source).to eq('LTCaregiverJobs.com')
                end
              end

              it 'creates a created contacts import' do
                expect {
                  subject.call
                }.to change { import.reload.contacts_imports.created.count }.by(1)
              end
            end
          end

          context 'invalid phone number' do
            let(:import) { create(:import, :no_id_column_invalid_phone_number, account: account) }

            it 'creates an invalid phone number import error' do
              expect {
                subject.call
              }.to change { import.reload.import_errors.invalid_phone_number.count }.by(1)
            end
          end

          context 'phone_number_blank' do
            let(:import) { create(:import, :no_id_column_missing_phone_number, account: account) }

            it 'creates a phone_number_blank import error' do
              expect {
                subject.call
              }.to change { import.reload.import_errors.blank_phone_number.count }.by(1)
            end
          end
        end
      end
    end

    context 'two valid rows' do
      context 'that are both valid' do
        context 'and new' do
          let(:import) { create(:import, :multiple, account: account) }

          it 'changes the import to complete' do
            expect {
              subject.call
            }.to change { import.reload.status }.to('complete')
          end

          it 'creates two contacts' do
            expect {
              subject.call
            }.to change { organization.reload.contacts.subscribed.count }.by(2)
          end

          it 'creates two created contacts import' do
            expect {
              subject.call
            }.to change { import.reload.contacts_imports.created.count }.by(2)
          end

          context 'tag' do
            let(:tag) { create(:tag) }
            before do
              import.tags << tag
            end

            it 'tags each contact with the import tag' do
              expect {
                subject.call
              }.to change { tag.reload.contacts.count }.by(2)
            end
          end
        end
      end
    end
  end
end
