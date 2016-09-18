require 'rails_helper'

RSpec.describe DocumentQuestionsController, type: :controller do
  let(:account) { create(:account, :with_subscription) }
  let!(:survey) { create(:survey, organization: account.organization) }

  before do
    sign_in(account)
  end

  let(:valid_attributes) do
    attributes_for(:document_question)
  end

  let(:invalid_attributes) do
    { text: '', label: '', type: 'DocumentQuestion' }
  end

  describe 'GET #new' do
    it 'assigns a new document_question as @question' do
      get :new, params: {}
      expect(assigns(:question)).to be_a_new(DocumentQuestion)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested document_question as @question' do
      document_question = survey.questions.create! valid_attributes
      get :edit, params: { id: document_question.to_param }
      expect(assigns(:question)).to eq(document_question)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new DocumentQuestion' do
        expect do
          post :create, params: { document_question: valid_attributes }
        end.to change(DocumentQuestion, :count).by(1)
      end

      it 'assigns a newly created document_question as @question' do
        post :create, params: { document_question: valid_attributes }
        expect(assigns(:question)).to be_a(DocumentQuestion)
        expect(assigns(:question)).to be_persisted
      end

      it 'redirects to the survey' do
        post :create, params: { document_question: valid_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved document_question as @question' do
        post :create, params: { document_question: invalid_attributes }
        expect(assigns(:question)).to be_a_new(DocumentQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, params: { document_question: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { text: 'New question text', label: 'New question label' }
      end

      it 'updates the requested document_question' do
        document_question = survey.questions.create! valid_attributes

        expect do
          put :update, params: { id: document_question.to_param, document_question: new_attributes }
        end.to change { document_question.reload.text }.to(new_attributes[:text])
      end

      it 'assigns the requested document_question as @question' do
        document_question = survey.questions.create! valid_attributes
        put :update, params: { id: document_question.to_param, document_question: new_attributes }
        expect(assigns(:question)).to eq(document_question)
      end

      it 'redirects to the survey' do
        document_question = survey.questions.create! valid_attributes
        put :update, params: { id: document_question.to_param, document_question: new_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the document_question as @question' do
        document_question = survey.questions.create! valid_attributes
        put :update, params: { id: document_question.to_param, document_question: invalid_attributes }
        expect(assigns(:question)).to eq(document_question)
      end

      it "re-renders the 'edit' template" do
        document_question = survey.questions.create! valid_attributes
        put :update, params: { id: document_question.to_param, document_question: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end
end
