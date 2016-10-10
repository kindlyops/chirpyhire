class WhitelistQuestion < Question
  has_many :whitelist_question_options,
           foreign_key: :question_id, inverse_of: :whitelist_question
  accepts_nested_attributes_for :whitelist_question_options,
                                reject_if: :all_blank, allow_destroy: true
  validates :whitelist_question_options, presence: true

  def self.extract_internal(properties, message, inquiry)
    properties[:whitelist_option] = message.body.strip
    properties
  end

  def self.child_class_property
    'whitelist'
  end
end
