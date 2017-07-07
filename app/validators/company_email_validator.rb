class CompanyEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value =~ BLOCKED_DOMAINS
      record.errors[attribute] << message
    end
  end

  def message
    options[:message] || 'must be your company email.'
  end
end
