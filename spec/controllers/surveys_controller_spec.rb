require 'rails_helper'

RSpec.describe SurveysController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  let(:valid_attributes) do
    attributes_for(:survey).merge(organization: organization, bad_fit: create(:template), welcome: create(:template), thank_you: create(:template), not_understood: create(:template))
  end
  let!(:survey) { Survey.create! valid_attributes }

  describe 'GET #show' do
    it 'assigns the requested survey as @survey' do
      get :show, params: { id: survey.to_param }
      expect(assigns(:survey)).to eq(survey)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested survey as @survey' do
      get :edit, params: { id: survey.to_param }
      expect(assigns(:survey)).to eq(survey)
    end
  end

  describe 'PUT #reorder' do
    let!(:first_question) { create(:document_question, survey: survey, priority: 1) }
    let!(:second_question) { create(:document_question, survey: survey, priority: 2) }

    context 'with valid params' do
      let(:params) {
        { questions: { first_question.id.to_s => { priority: 2 }, second_question.id.to_s => { priority: 1 } } }
      }

      it 'updates the requested survey' do
        expect {
          expect {
            put :reorder, params: params
          }.to change { first_question.reload.priority }.to(2)
        }.to change { second_question.reload.priority }.to(1)
      end

      it 'redirects to the survey path' do
        put :reorder, params: params
        expect(response).to redirect_to(survey_path)
      end
    end
  end
end
