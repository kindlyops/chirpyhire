class ZipcodeFollowUp < FollowUp
  def activated?(message)
    Bot::ZipcodeAnswer.new(self).activated?(message)
  end
end
