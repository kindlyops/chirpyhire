require 'rails_helper'

RSpec.describe YesNoQuestionsController, type: :controller do
  let(:account) { create(:account, :with_subscription) }
  let!(:survey) { create(:survey, organization: account.organization) }

  before do
    sign_in(account)
  end

  let(:valid_attributes) do
    attributes_for(:yes_no_question)
  end

  let(:invalid_attributes) {
    { text: '', label: '', type: 'YesNoQuestion' }
  }

  describe 'GET #new' do
    it 'assigns a new yes_no_question as @question' do
      get :new, params: {}
      expect(assigns(:question)).to be_a_new(YesNoQuestion)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested yes_no_question as @question' do
      yes_no_question = survey.questions.create! valid_attributes
      get :edit, params: { id: yes_no_question.to_param }
      expect(assigns(:question)).to eq(yes_no_question)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new YesNoQuestion' do
        expect {
          post :create, params: { yes_no_question: valid_attributes }
        }.to change(YesNoQuestion, :count).by(1)
      end

      it 'assigns a newly created yes_no_question as @question' do
        post :create, params: { yes_no_question: valid_attributes }
        expect(assigns(:question)).to be_a(YesNoQuestion)
        expect(assigns(:question)).to be_persisted
      end

      it 'redirects to the survey' do
        post :create, params: { yes_no_question: valid_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved yes_no_question as @question' do
        post :create, params: { yes_no_question: invalid_attributes }
        expect(assigns(:question)).to be_a_new(YesNoQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, params: { yes_no_question: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { text: 'New question text', label: 'New question label' }
      }

      it 'updates the requested yes_no_question' do
        yes_no_question = survey.questions.create! valid_attributes

        expect {
          put :update, params: { id: yes_no_question.to_param, yes_no_question: new_attributes }
        }.to change { yes_no_question.reload.text }.to(new_attributes[:text])
      end

      it 'assigns the requested yes_no_question as @question' do
        yes_no_question = survey.questions.create! valid_attributes
        put :update, params: { id: yes_no_question.to_param, yes_no_question: new_attributes }
        expect(assigns(:question)).to eq(yes_no_question)
      end

      it 'redirects to the survey' do
        yes_no_question = survey.questions.create! valid_attributes
        put :update, params: { id: yes_no_question.to_param, yes_no_question: new_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the yes_no_question as @question' do
        yes_no_question = survey.questions.create! valid_attributes
        put :update, params: { id: yes_no_question.to_param, yes_no_question: invalid_attributes }
        expect(assigns(:question)).to eq(yes_no_question)
      end

      it "re-renders the 'edit' template" do
        yes_no_question = survey.questions.create! valid_attributes
        put :update, params: { id: yes_no_question.to_param, yes_no_question: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end
end
