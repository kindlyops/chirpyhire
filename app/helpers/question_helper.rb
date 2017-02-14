module QuestionHelper
  include ActionView::Helpers::UrlHelper

  def new_question_link(path, extra_class = '')
    link_to 'Add Question', path, class: "btn btn-primary #{extra_class}"
  end
end
