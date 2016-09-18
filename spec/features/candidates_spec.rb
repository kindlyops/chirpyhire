require 'rails_helper'

RSpec.feature 'Candidates', type: :feature, js: true do
  let(:organization) { create(:organization, :with_subscription, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:user) { create(:user, organization: organization) }
  let(:account) { create(:account, user: user) }

  before do
    login_as(account, scope: :account)
  end

  context 'with candidates' do
    context 'qualified candidates' do
      let!(:candidate) { create(:candidate, organization: account.organization, status: 'Qualified') }

      context 'marking as hired' do
        it 'lets the account mark a candidate as hired' do
          visit candidates_path

          click_button('hired')
          expect(page).to have_text("Nice! #{candidate.phone_number.phony_formatted} marked as Hired")
        end
      end

      context 'with candidate features' do
        let(:survey) { create(:survey, organization: account.organization) }
        context 'with address persona feature' do
          let(:label) { 'Address Category' }
          let!(:question) { create(:address_question, label: label, survey: survey) }

          context 'with address' do
            let!(:address) { Address.new(create(:candidate_feature, :address, label: label, candidate: candidate)) }

            it 'has a link to the address' do
              visit candidates_path
              expect(page).to have_text(address.formatted_address)
            end
          end
        end

        context 'with document persona feature' do
          let(:label) { 'Document Category' }
          let!(:question) { create(:question, label: label, survey: survey) }

          context 'with document' do
            before do
              create(:candidate_feature, label: label, candidate: candidate, properties: { url0: '/path/to/image', child_class: 'document' })
            end

            it 'has a link to the document' do
              visit candidates_path
              expect(page).to have_selector("a[href='/path/to/image']")
              expect(page).to have_text('Document Category')
            end
          end
        end

        context 'with choice persona feature' do
          let(:label) { 'Choice Category' }
          let!(:question) { create(:question, :choice, label: label, survey: survey) }

          context 'with choice' do
            before do
              create(:candidate_feature, label: label, candidate: candidate, properties: { choice_option: 'Live-in', child_class: 'choice' })
            end

            it 'shows the choice' do
              visit candidates_path
              expect(page).to have_text('Choice Category')
              expect(page).to have_text('Live-in')
            end
          end
        end
      end

      context 'viewing messages' do
        it "lets the account view the user's messages" do
          visit candidates_path

          click_button("user-#{candidate.user_id}-messages")
          expect(page).to have_text('Send')
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end

    context 'hired candidates' do
      let!(:candidate) { create(:candidate, organization: account.organization, status: 'Hired') }

      it 'lets the account call the candidate' do
        visit candidates_path << '?status=Hired'
        call_button = find_button("call-#{candidate.user_id}")
        expect(call_button.present?).to eq(true)
      end

      context 'marking as bad fit' do
        it 'lets the account mark a candidate as bad fit' do
          visit candidates_path << '?status=Hired'

          click_button('bad-fit')
          expect(page).to have_text("Nice! #{candidate.phone_number.phony_formatted} marked as Bad Fit")
        end
      end
    end

    context 'filtering' do
      context 'default' do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ['Potential', 'Bad Fit', 'Hired'][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: 'Qualified') }

        it 'only shows Qualified candidates by default' do
          visit candidates_path

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end

          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end

        context 'with a qualified candidate created a month ago' do
          let!(:old_qualified_candidate) { create(:candidate, organization: account.organization, status: 'Qualified', created_at: 1.month.ago) }

          it 'only shows candidates from the past week by default' do
            visit candidates_path

            expect(page).not_to have_text(old_qualified_candidate.phone_number.phony_formatted)
          end
        end
      end

      context 'Bad Fit' do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: %w(Potential Hired Qualified)[index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: 'Bad Fit') }

        it 'only shows bad fit candidates' do
          visit candidates_path << '?status=Bad Fit'

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end

        context 'marking as qualified' do
          it 'lets the account mark a candidate as qualified' do
            visit candidates_path << '?status=Bad Fit'

            click_button('qualified')
            expect(page).to have_text("Nice! #{candidate.phone_number.phony_formatted} marked as Qualified")
          end
        end
      end

      context 'Hired' do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ['Potential', 'Bad Fit', 'Qualified'][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: 'Hired') }

        it 'only shows Hired candidates' do
          visit candidates_path << '?status=Hired'

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context 'Qualified' do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ['Potential', 'Hired', 'Bad Fit'][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: 'Qualified') }

        it 'only shows qualified candidates' do
          visit candidates_path << '?status=Qualified'

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end

      context 'Potential' do
        let(:users) { create_list(:user, 3, organization: account.organization) }
        let!(:candidates) do
          users.each_with_index do |user, index|
            create(:candidate, status: ['Bad Fit', 'Hired', 'Qualified'][index], user: user)
          end
        end

        let!(:candidate) { create(:candidate, organization: account.organization, status: 'Potential') }

        it 'only shows potential candidates' do
          visit candidates_path << '?status=Potential'

          candidates.each do |candidate|
            expect(page).not_to have_text(candidate.phone_number.phony_formatted)
          end
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end

    context 'more than one page of candidates' do
      let(:users) { create_list(:user, 14, organization: account.organization) }
      let!(:candidates) do
        users.each do |user|
          create(:candidate, status: 'Qualified', user: user)
        end
      end

      it 'allows you to page to the next group of candidates' do
        visit candidates_path
        candidates[0..2].each do |candidate|
          expect(page).not_to have_text(candidate.phone_number.phony_formatted)
        end

        click_link('2')

        candidates[0..2].each do |candidate|
          expect(page).to have_text(candidate.phone_number.phony_formatted)
        end
      end
    end
  end
end
