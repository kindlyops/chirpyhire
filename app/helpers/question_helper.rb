module QuestionHelper
  include ActionView::Helpers::UrlHelper

  def new_question_link(path)
    link_to 'Add Question', path, class: 'button'
  end
end
