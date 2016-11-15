class Constraint::Answer < Constraint::ConstraintBase
  def matches?(request)
    @request = request
    candidate_present? && outstanding_inquiry.present?
  end
end
