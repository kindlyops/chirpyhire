require 'rails_helper'

RSpec.describe WhitelistQuestionsController, type: :controller do
  let(:account) { create(:account, :with_subscription) }
  let!(:survey) { create(:survey, organization: account.organization) }

  before(:each) do
    sign_in(account)
  end

  let(:valid_attributes) do
    attributes_for(:whitelist_question)
  end

  let(:invalid_attributes) {
    { text: '', label: '', type: 'WhitelistQuestion' }
  }

  describe 'GET #new' do
    it 'assigns a new whitelist_question as @question' do
      get :new, params: {}
      expect(assigns(:question)).to be_a_new(WhitelistQuestion)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested whitelist_question as @question' do
      whitelist_question = survey.questions.create! valid_attributes
      get :edit, params: { id: whitelist_question.id }
      expect(assigns(:question)).to eq(whitelist_question)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new WhitelistQuestion' do
        expect {
          post :create, params: { whitelist_question: valid_attributes }
        }.to change(WhitelistQuestion, :count).by(1)
      end

      it 'assigns a newly created whitelist_question as @question' do
        post :create, params: { whitelist_question: valid_attributes }
        expect(assigns(:question)).to be_a(WhitelistQuestion)
        expect(assigns(:question)).to be_persisted
      end

      it 'redirects to the survey' do
        post :create, params: { whitelist_question: valid_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved whitelist_question as @question' do
        post :create, params: { whitelist_question: invalid_attributes }
        expect(assigns(:question)).to be_a_new(WhitelistQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, params: { whitelist_question: invalid_attributes }
        expect(response).to render_template('new')
      end
    end

    context 'with whitelist question option' do
      context 'with valid params' do
        let(:valid_attributes) {
          attributes_for(:whitelist_question).merge(whitelist_question_options_attributes: [attributes_for(:whitelist_question_option)])
        }

        it 'creates a whitelist question option' do
          expect {
            post :create, params: { whitelist_question: valid_attributes }
          }.to change(WhitelistQuestionOption, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_attributes) do
          { text: 'Valid text', label: 'Valid label', type: 'WhitelistQuestion', whitelist_question_options_attributes: [{ text: '' }] }
        end

        it 'does not create an whitelist question' do
          expect {
            post :create, params: { whitelist_question: invalid_attributes }
          }.not_to change(WhitelistQuestion, :count)
        end

        it 'does not create an whitelist question option' do
          expect {
            post :create, params: { whitelist_question: invalid_attributes }
          }.not_to change(WhitelistQuestionOption, :count)
        end

        it "re-renders the 'new' template" do
          post :create, params: { whitelist_question: invalid_attributes }
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

      it 'updates the requested whitelist_question' do
        whitelist_question = survey.questions.create! valid_attributes

        expect {
          put :update, params: { id: whitelist_question.id, whitelist_question: new_attributes }
        }.to change { whitelist_question.reload.text }.to(new_attributes[:text])
      end

      it 'assigns the requested whitelist_question as @question' do
        whitelist_question = survey.questions.create! valid_attributes
        put :update, params: { id: whitelist_question.id, whitelist_question: new_attributes }
        expect(assigns(:question)).to eq(whitelist_question)
      end

      it 'redirects to the survey' do
        whitelist_question = survey.questions.create! valid_attributes
        put :update, params: { id: whitelist_question.id, whitelist_question: new_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with choice question option' do
      context 'with valid params' do
        let(:valid_attributes) {
          attributes_for(:whitelist_question).merge(whitelist_question_options_attributes: [attributes_for(:whitelist_question_option)])
        }

        let(:new_attributes) {
          { text: 'New question text', label: 'New question label', whitelist_question_options_attributes: [{ text: 'Foo' }] }
        }

        it 'updates the requested whitelist_question_option' do
          whitelist_question = survey.questions.create! valid_attributes
          whitelist_question_option = whitelist_question.whitelist_question_options.first
          new_attributes[:whitelist_question_options_attributes].first[:id] = whitelist_question_option.id

          expect {
            put :update, params: { id: whitelist_question.id, whitelist_question: new_attributes }
          }.to change { whitelist_question_option.reload.text }.to(new_attributes[:whitelist_question_options_attributes].first[:text])
        end
      end

      context 'with invalid params' do
        let(:valid_attributes) {
          attributes_for(:whitelist_question)
        }

        let(:invalid_attributes) do
          { text: 'Valid text', label: '', type: 'WhitelistQuestion', whitelist_question_options_attributes: [{ text: '' }] }
        end

        it "re-renders the 'edit' template" do
          whitelist_question = survey.questions.create! valid_attributes

          put :update, params: { id: whitelist_question.id, whitelist_question: invalid_attributes }
          expect(response).to render_template('edit')
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the whitelist_question as @question' do
        whitelist_question = survey.questions.create! valid_attributes
        put :update, params: { id: whitelist_question.id, whitelist_question: invalid_attributes }
        expect(assigns(:question)).to eq(whitelist_question)
      end

      it "re-renders the 'edit' template" do
        whitelist_question = survey.questions.create! valid_attributes
        put :update, params: { id: whitelist_question.id, whitelist_question: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end
end
