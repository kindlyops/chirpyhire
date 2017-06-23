class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, :handle, :phone_number, to: :person

  def near_query_params
    near_params.delete_if { |_, v| v.blank? }
  end

  def joined_at
    Contact::JoinedAt.new(object)
  end

  def last_active_at
    Contact::LastActiveAt.new(object)
  end

  def candidacy_zipcode
    Contact::ZipCode.new(object)
  end
end
