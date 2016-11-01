module QuestionHelper
  include ActionView::Helpers::UrlHelper

  def new_question_link(path, extra_class = "")
    link_to 'Add Question', path, class: "button #{extra_class}"
  end
end
