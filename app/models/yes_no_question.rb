class YesNoQuestion < Question
  REGEXP = /\A(yes|no|y|n)\z/
  def self.extract_internal(properties, message, _inquiry)
    answer = message.body.strip.downcase
    yes_no_option = YesNoQuestion::REGEXP.match(answer)[1]

    properties[:yes_no_option] = options[yes_no_option.to_sym]
    properties
  end

  def self.child_class_property
    'yes_no'
  end

  def rejects?(candidate)
    feature = candidate.candidate_features
                       .where(label: label)
                       .find_by("properties->>'child_class' = ?", 'yes_no')

    feature['properties']['yes_no_option'] == 'No'
  end

  def formatted_text
    <<-template
#{text}

Please reply with just Yes or No.
template
  end

  def self.options
    {
      y: 'Yes',
      yes: 'Yes',
      no: 'No',
      n: 'No'
    }
  end
end
