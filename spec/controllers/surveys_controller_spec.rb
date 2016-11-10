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

  describe 'PUT #update' do
    let!(:first_question) { create(:document_question, survey: survey, priority: 1) }
    let!(:second_question) { create(:document_question, survey: survey, priority: 2) }

    context 'with valid params' do
      let(:new_attributes) {
        { questions_attributes: [{ id: first_question.id, priority: 2 }, { id: second_question.id, priority: 1 }] }
      }

      it 'updates the requested survey' do
        expect {
          expect {
            put :update, params: { id: survey.to_param, survey: new_attributes }
          }.to change { first_question.reload.priority }.to(2)
        }.to change { second_question.reload.priority }.to(1)
      end

      it 'assigns the requested survey as @survey' do
        put :update, params: { id: survey.to_param, survey: valid_attributes }
        expect(assigns(:survey)).to eq(survey)
      end

      it 'redirects to the survey path' do
        put :update, params: { id: survey.to_param, survey: valid_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) {
        { questions_attributes: [{ id: first_question.id, priority: 1 }, { id: second_question.id, priority: 1 }] }
      }

      it 'assigns the survey as @survey' do
        put :update, params: { id: survey.to_param, survey: invalid_attributes }
        expect(assigns(:survey)).to eq(survey)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: survey.to_param, survey: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end
end
