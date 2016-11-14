class Constraint::Answer
  include Constraint::ConstraintHelper

  def matches?(request)
    @request = request
    candidate_present? && outstanding_inquiry.present?
  end
end
