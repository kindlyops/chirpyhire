require 'rails_helper'

RSpec.feature 'Stage Management', type: :feature, js: true do
  let(:organization) { create(:organization, :with_subscription, :with_account, phone_number: Faker::PhoneNumber.cell_phone) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  background(:each) do
    login_as(account, scope: :account)
  end

  describe 'creating a stage', vcr: { cassette_name: 'Stage-Management-creating-a-stage' } do
    it 'works' do
      visit stages_path
      within(find('.new-stage-wrapper')) do
        fill_in 'new_stage', with: 'Contacted'
      end

      click_on 'Add Stage'
      expect(page).to have_current_path(%r{/stages/?})
      expect(page).to have_text('Nice! Stage created.')
    end
  end

  describe 'modyfing a stage' do
    let!(:extra_stage) { create(:stage, organization: organization, name: 'Extra Stage', order: StageDefaults.count + 1) }

    describe 'changing stage name', vcr: { cassette_name: 'Stage-Management-changing-stage-name' } do
      it 'works' do
        visit edit_stage_path(extra_stage)

        within(find('.edit-stages-wrapper')) do
          fill_in 'name', with: 'Changed stage'
        end

        click_on 'Save'
        expect(page).to have_current_path(%r{/stages/?})
        expect(page).to have_text('Changed stage')
      end
    end

    describe 'deleting a stage', vcr: { cassette_name: 'Stage-Management-deleting-a-stage' } do
      it 'works' do
        visit stages_path

        within(all('li.stage').last) do
          click_on '×'
        end

        expect(page).not_to have_text('Extra stage')
      end
    end
  end
end
