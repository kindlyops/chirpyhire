module Constraint
  class Answer
    def matches?(request)
      @request = request

      user.present? && candidate.present? && outstanding_inquiry.present?
    end

    private

    attr_reader :request

    def candidate
      user.candidate
    end

    def outstanding_inquiry
      user.outstanding_inquiry
    end

    def user
      @user ||= organization.users.find_by(phone_number: from)
    end

    def organization
      Organization.find_by(phone_number: to)
    end

    def to
      request.request_parameters["To"]
    end

    def from
      request.request_parameters["From"]
    end
  end
end
