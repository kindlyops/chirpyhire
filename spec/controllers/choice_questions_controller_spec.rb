require 'rails_helper'

RSpec.describe ChoiceQuestionsController, type: :controller do
  let(:account) { create(:account) }
  let!(:survey) { account.organization.create_survey }

  before(:each) do
    sign_in(account)
  end

  let(:valid_attributes) {
    attributes_for(:choice_question)
  }

  let(:invalid_attributes) {
    { text: "", label: "", type: "ChoiceQuestion" }
  }

  describe "GET #new" do
    it "assigns a new choice_question as @question" do
      get :new, params: {}
      expect(assigns(:question)).to be_a_new(ChoiceQuestion)
    end
  end

  describe "GET #edit" do
    it "assigns the requested choice_question as @question" do
      choice_question = survey.questions.create! valid_attributes
      get :edit, params: {id: choice_question.to_param}
      expect(assigns(:question)).to eq(choice_question)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ChoiceQuestion" do
        expect {
          post :create, params: {choice_question: valid_attributes}
        }.to change(ChoiceQuestion, :count).by(1)
      end

      it "assigns a newly created choice_question as @question" do
        post :create, params: {choice_question: valid_attributes}
        expect(assigns(:question)).to be_a(ChoiceQuestion)
        expect(assigns(:question)).to be_persisted
      end

      it "redirects to the survey" do
        post :create, params: {choice_question: valid_attributes}
        expect(response).to redirect_to(survey_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved choice_question as @question" do
        post :create, params: {choice_question: invalid_attributes}
        expect(assigns(:question)).to be_a_new(ChoiceQuestion)
      end

      it "re-renders the 'new' template" do
        post :create, params: {choice_question: invalid_attributes}
        expect(response).to render_template("new")
      end
    end

    context "with choice question option" do
      context "with valid params" do

        let(:valid_attributes) {
          attributes_for(:choice_question).merge(choice_question_options_attributes: [attributes_for(:choice_question_option)])
        }

        it "creates an choice question option" do
          expect {
            post :create, params: {choice_question: valid_attributes}
          }.to change(ChoiceQuestionOption, :count).by(1)
        end
      end

      context "with invalid params" do
        let(:invalid_attributes) do
          { text: "Valid text", label: "Valid label", type: "ChoiceQuestion", choice_question_options_attributes: [{ text: "Foo" }] }
        end

        it "does not create an choice question" do
          expect {
            post :create, params: {choice_question: invalid_attributes}
          }.not_to change(ChoiceQuestion, :count)
        end

        it "does not create an choice question option" do
          expect {
            post :create, params: {choice_question: invalid_attributes}
          }.not_to change(ChoiceQuestionOption, :count)
        end

        it "re-renders the 'new' template" do
          post :create, params: {choice_question: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end
  end

  describe "PUT #update" do
    context "versions of choice options" do
      let!(:question) { create(:choice_question, survey: survey, choice_question_options_attributes: [
          { letter: "a", text: "original A"}
        ]) }

      context "with existing choice options" do
        let!(:old_choice_question_option) { question.choice_question_options.first }

        context "and only changing choice options" do
          let(:params) do
            {
              id: question.id,
              choice_question: {
                choice_question_options_attributes: [
                  id: old_choice_question_option.id,
                  letter: "q"
                ]
              }
            }
          end

          it "still changes the updated_at on the question" do
            expect {
              put :update, params: params
            }.to change{question.reload.updated_at}
          end

          with_versioning do
            it "tracks the prior association" do
              put :update, params: params
              old_question = question.versions.last.reify(has_many: true)
              expect(old_question.choice_question_options.map(&:letter)).to match_array(["a"])
            end
          end
        end
      end
    end

    context "with valid params" do
      let(:new_attributes) {
        { text: "New question text", label: "New question label" }
      }

      it "updates the requested choice_question" do
        choice_question = survey.questions.create! valid_attributes

        expect {
          put :update, params: {id: choice_question.to_param, choice_question: new_attributes}
        }.to change{choice_question.reload.text}.to(new_attributes[:text])
      end

      it "assigns the requested choice_question as @question" do
        choice_question = survey.questions.create! valid_attributes
        put :update, params: {id: choice_question.to_param, choice_question: new_attributes}
        expect(assigns(:question)).to eq(choice_question)
      end

      it "redirects to the survey" do
        choice_question = survey.questions.create! valid_attributes
        put :update, params: {id: choice_question.to_param, choice_question: new_attributes}
        expect(response).to redirect_to(survey_path)
      end
    end

    context "with choice question option" do
      context "with valid params" do
        let(:valid_attributes) {
          attributes_for(:choice_question).merge(choice_question_options_attributes: [attributes_for(:choice_question_option)])
        }

        let(:new_attributes) {
          { text: "New question text", label: "New question label", choice_question_options_attributes: [{ text: "Foo" }] }
        }

        it "updates the requested choice_question_option" do
          choice_question = survey.questions.create! valid_attributes
          choice_question_option = choice_question.choice_question_options.first
          new_attributes[:choice_question_options_attributes].first[:id] = choice_question_option.id

          expect {
            put :update, params: {id: choice_question.to_param, choice_question: new_attributes}
          }.to change{choice_question_option.reload.text}.to(new_attributes[:choice_question_options_attributes].first[:text])
        end
      end

      context "with invalid params" do
        let(:valid_attributes) {
          attributes_for(:choice_question)
        }

        let(:invalid_attributes) do
          { text: "Valid text", label: "Valid label", type: "AddressQuestion", choice_question_options_attributes: [{ text: "Foo" }] }
        end

        it "re-renders the 'edit' template" do
          choice_question = survey.questions.create! valid_attributes

          put :update, params: {id: choice_question.to_param, choice_question: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    context "with invalid params" do
      it "assigns the choice_question as @question" do
        choice_question = survey.questions.create! valid_attributes
        put :update, params: {id: choice_question.to_param, choice_question: invalid_attributes}
        expect(assigns(:question)).to eq(choice_question)
      end

      it "re-renders the 'edit' template" do
        choice_question = survey.questions.create! valid_attributes
        put :update, params: {id: choice_question.to_param, choice_question: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end
end
