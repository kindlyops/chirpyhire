class CompanyEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << message if value.match?(BLOCKED_DOMAINS)
  end

  def message
    options[:message] || 'must be your company email.'
  end
end
