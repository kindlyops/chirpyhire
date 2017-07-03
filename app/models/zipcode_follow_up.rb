class ZipcodeFollowUp < FollowUp
  def tag(*); end

  def activated?(message)
    Bot::ZipcodeAnswer.new(self).activated?(message)
  end
end
