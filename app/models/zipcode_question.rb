class ZipcodeQuestion < Question
  alias_attribute :restated, :body

  def follow_up_type
    'ZipcodeFollowUp'
  end
end
