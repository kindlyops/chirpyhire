class ZipcodeQuestion < Question
  alias restated body

  def follow_up_type
    'ZipcodeFollowUp'
  end
end
