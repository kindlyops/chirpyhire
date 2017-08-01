class ManualMessagePolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:title, :body, audience: audience]
  end

  def audience
    %i[city state county zipcode name messages]
      .concat([tag: [], contact_stage: []])
  end
end
