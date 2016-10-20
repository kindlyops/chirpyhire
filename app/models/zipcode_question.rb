class ZipcodeQuestion < Question
  has_many :zipcode_question_options,
           foreign_key: :question_id, inverse_of: :zipcode_question
  accepts_nested_attributes_for :zipcode_question_options,
                                reject_if: :all_blank, allow_destroy: true
  validates :zipcode_question_options, presence: true
  validate :zipcode_is_five_digits

  def self.extract_internal(properties, message, _inquiry)
    properties[:option] = message.body.strip
    properties
  end

  def self.child_class_property
    'zipcode'
  end

  def zipcode_is_five_digits
    all_zipcodes = zipcode_question_options.all? do |option|
      (option.text =~ /^\d{5}$/) == 0
    end
    if !all_zipcodes
      errors.add(:zipcode_question_options, "must be five digits")
    end
  end
end
