require 'rails_helper'

RSpec.describe AddressQuestionsController, type: :controller do
  let(:account) { create(:account, :with_subscription) }
  let!(:survey) { create(:survey, organization: account.organization) }

  before(:each) do
    create(:location, organization: account.organization)
    sign_in(account)
  end

  let(:valid_attributes) do
    attributes_for(:address_question)
  end

  let(:invalid_attributes) {
    { text: '', label: '', type: 'AddressQuestion' }
  }

  describe 'GET #new' do
    it 'assigns a new address_question as @address_question' do
      get :new, params: {}
      expect(assigns(:question)).to be_a_new(AddressQuestion)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested address_question as @address_question' do
      address_question = survey.questions.create! valid_attributes
      get :edit, params: { id: address_question.to_param }
      expect(assigns(:question)).to eq(address_question)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new AddressQuestion' do
        expect {
          post :create, params: { address_question: valid_attributes }
        }.to change(AddressQuestion, :count).by(1)
      end

      it 'assigns a newly created address_question as @address_question' do
        post :create, params: { address_question: valid_attributes }
        expect(assigns(:question)).to be_a(AddressQuestion)
        expect(assigns(:question)).to be_persisted
      end

      it 'redirects to the survey' do
        post :create, params: { address_question: valid_attributes }
        expect(response).to redirect_to(survey_path)
      end

      context 'with address question option' do
        context 'with valid params' do
          let(:valid_attributes) {
            attributes_for(:address_question).merge(address_question_option_attributes: attributes_for(:address_question_option))
          }

          it 'creates an address question option' do
            expect {
              post :create, params: { address_question: valid_attributes }
            }.to change(AddressQuestionOption, :count).by(1)
          end
        end

        context 'with invalid params' do
          let(:invalid_attributes) do
            { text: 'Valid text', label: 'Valid label', type: 'AddressQuestion', address_question_option_attributes: { distance: 10 } }
          end

          it 'does not create an address question' do
            expect {
              post :create, params: { address_question: invalid_attributes }
            }.not_to change(AddressQuestion, :count)
          end

          it 'does not create an address question option' do
            expect {
              post :create, params: { address_question: invalid_attributes }
            }.not_to change(AddressQuestionOption, :count)
          end

          it "re-renders the 'new' template" do
            post :create, params: { address_question: invalid_attributes }
            expect(response).to render_template('new')
          end
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved address_question as @address_question' do
        post :create, params: { address_question: invalid_attributes }
        expect(assigns(:question)).to be_a_new(AddressQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, params: { address_question: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { text: 'New question text', label: 'New question label' }
      }

      it 'updates the requested address_question' do
        address_question = survey.questions.create! valid_attributes
        expect {
          put :update, params: { id: address_question.to_param, address_question: new_attributes }
        }.to change { address_question.reload.text }.to(new_attributes[:text])
      end

      it 'assigns the requested address_question as @address_question' do
        address_question = survey.questions.create! valid_attributes
        put :update, params: { id: address_question.to_param, address_question: new_attributes }
        expect(assigns(:question)).to eq(address_question)
      end

      it 'redirects to the survey' do
        address_question = survey.questions.create! valid_attributes
        put :update, params: { id: address_question.to_param, address_question: new_attributes }
        expect(response).to redirect_to(survey_path)
      end
    end

    context 'with address question option' do
      context 'with valid params' do
        let(:valid_attributes) {
          attributes_for(:address_question).merge(address_question_option_attributes: attributes_for(:address_question_option))
        }

        let(:new_attributes) {
          { text: 'New question text', label: 'New question label', address_question_option_attributes: { distance: 1 } }
        }

        it 'updates the requested address_question_option' do
          address_question = survey.questions.create! valid_attributes
          address_question_option = address_question.address_question_option
          new_attributes[:address_question_option_attributes][:id] = address_question_option.id

          expect {
            put :update, params: { id: address_question.to_param, address_question: new_attributes }
          }.to change { address_question_option.reload.distance }.to(new_attributes[:address_question_option_attributes][:distance])
        end
      end

      context 'with invalid params' do
        let(:valid_attributes) {
          attributes_for(:address_question)
        }

        let(:invalid_attributes) do
          { text: 'Valid text', label: 'Valid label', type: 'AddressQuestion', address_question_option_attributes: { distance: 10 } }
        end

        it "re-renders the 'edit' template" do
          address_question = survey.questions.create! valid_attributes

          put :update, params: { id: address_question.to_param, address_question: invalid_attributes }
          expect(response).to render_template('edit')
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the address_question as @address_question' do
        address_question = survey.questions.create! valid_attributes
        put :update, params: { id: address_question.to_param, address_question: invalid_attributes }
        expect(assigns(:question)).to eq(address_question)
      end

      it "re-renders the 'edit' template" do
        address_question = survey.questions.create! valid_attributes
        put :update, params: { id: address_question.to_param, address_question: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end
end
