class OrganizationPolicy < ApplicationPolicy
  def show?
    record == organization
  end

  def update?
    show?
  end

  def permitted_attributes
    attributes = basic_attributes.concat(question_attributes)
    attributes.push(:billing_email) if account.owner?
    attributes
  end

  def basic_attributes
    %i[name avatar email description url forwarding_phone_number]
  end

  def question_attributes
    %i[certification availability live_in experience transportation zipcode
       cpr_first_aid skin_test drivers_license]
  end
end
