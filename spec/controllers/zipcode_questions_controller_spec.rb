require 'rails_helper'

RSpec.describe ZipcodeQuestionsController, type: :controller do
  let(:account) { create(:account, :with_subscription) }
  let!(:survey) { create(:survey, organization: account.organization) }

  before(:each) do
    sign_in(account)
  end

  let(:valid_attributes) do
    attributes_for(:zipcode_question)
  end

  let(:invalid_attributes) {
    { text: '', label: '', type: ZipcodeQuestion.name }
  }

  describe 'GET #new' do
    it 'assigns a new zipcode_question as @question' do
      get :new, params: {}
      expect(assigns(:question)).to be_a_new(ZipcodeQuestion)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested zipcode_question as @question' do
      zipcode_question = survey.questions.create! valid_attributes
      get :edit, params: { id: zipcode_question.id }
      expect(assigns(:question)).to eq(zipcode_question)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ZipcodeQuestion' do
        expect {
          post :create, params: { zipcode_question: valid_attributes }
        }.to change(ZipcodeQuestion, :count).by(1)
      end

      it 'assigns a newly created zipcode_question as @question' do
        post :create, params: { zipcode_question: valid_attributes }
        expect(assigns(:question)).to be_a(ZipcodeQuestion)
        expect(assigns(:question)).to be_persisted
      end

      it 'redirects to the survey' do
        post :create, params: { zipcode_question: valid_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved zipcode_question as @question' do
        post :create, params: { zipcode_question: invalid_attributes }
        expect(assigns(:question)).to be_a_new(ZipcodeQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, params: { zipcode_question: invalid_attributes }
        expect(response).to render_template('new')
      end
    end

    context 'with zipcode question option' do
      context 'with valid params' do
        let(:valid_attributes) {
          attributes_for(:zipcode_question).merge(zipcode_question_options_attributes: [attributes_for(:zipcode_question_option)])
        }

        it 'creates a zipcode question option' do
          expect {
            post :create, params: { zipcode_question: valid_attributes }
          }.to change(ZipcodeQuestionOption, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_attributes) do
          { text: 'Valid text', label: 'Valid label', type: ZipcodeQuestion.name, zipcode_question_options_attributes: [{ text: '' }] }
        end

        it 'does not create an zipcode question' do
          expect {
            post :create, params: { zipcode_question: invalid_attributes }
          }.not_to change(ZipcodeQuestion, :count)
        end

        it 'does not create an zipcode question option' do
          expect {
            post :create, params: { zipcode_question: invalid_attributes }
          }.not_to change(ZipcodeQuestionOption, :count)
        end

        it "re-renders the 'new' template" do
          post :create, params: { zipcode_question: invalid_attributes }
          expect(response).to render_template('new')
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { text: 'New question text', label: 'New question label' }
      }

      it 'updates the requested zipcode_question' do
        zipcode_question = survey.questions.create! valid_attributes

        expect {
          put :update, params: { id: zipcode_question.id, zipcode_question: new_attributes }
        }.to change { zipcode_question.reload.text }.to(new_attributes[:text])
      end

      it 'assigns the requested zipcode_question as @question' do
        zipcode_question = survey.questions.create! valid_attributes
        put :update, params: { id: zipcode_question.id, zipcode_question: new_attributes }
        expect(assigns(:question)).to eq(zipcode_question)
      end

      it 'redirects to the survey' do
        zipcode_question = survey.questions.create! valid_attributes
        put :update, params: { id: zipcode_question.id, zipcode_question: new_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with choice question option' do
      context 'with valid params' do
        let(:valid_attributes) {
          attributes_for(:zipcode_question).merge(zipcode_question_options_attributes: [attributes_for(:zipcode_question_option)])
        }

        let(:new_attributes) {
          { text: 'New question text', label: 'New question label', zipcode_question_options_attributes: [{ text: '12345' }] }
        }

        it 'updates the requested zipcode_question_option' do
          zipcode_question = survey.questions.create! valid_attributes
          zipcode_question_option = zipcode_question.zipcode_question_options.first
          new_attributes[:zipcode_question_options_attributes].first[:id] = zipcode_question_option.id

          expect {
            put :update, params: { id: zipcode_question.id, zipcode_question: new_attributes }
          }.to change { zipcode_question_option.reload.text }.to(new_attributes[:zipcode_question_options_attributes].first[:text])
        end
      end

      context 'with invalid params' do
        let(:valid_attributes) {
          attributes_for(:zipcode_question)
        }

        let(:invalid_attributes) do
          { text: 'Valid text', label: '', type: ZipcodeQuestion.name, zipcode_question_options_attributes: [{ text: '' }] }
        end

        it "re-renders the 'edit' template" do
          zipcode_question = survey.questions.create! valid_attributes

          put :update, params: { id: zipcode_question.id, zipcode_question: invalid_attributes }
          expect(response).to render_template('edit')
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the zipcode_question as @question' do
        zipcode_question = survey.questions.create! valid_attributes
        put :update, params: { id: zipcode_question.id, zipcode_question: invalid_attributes }
        expect(assigns(:question)).to eq(zipcode_question)
      end

      it "re-renders the 'edit' template" do
        zipcode_question = survey.questions.create! valid_attributes
        put :update, params: { id: zipcode_question.id, zipcode_question: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end
end
