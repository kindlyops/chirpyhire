class OrganizationPolicy < ApplicationPolicy
  def show?
    record == organization
  end

  def update?
    show?
  end

  def permitted_attributes
    basic_attributes.concat(question_attributes)
  end

  def basic_attributes
    %i[name avatar email description url forwarding_phone_number
       billing_email invoice_notification]
  end

  def question_attributes
    %i[certification availability live_in experience transportation zipcode
       cpr_first_aid skin_test drivers_license]
  end
end
