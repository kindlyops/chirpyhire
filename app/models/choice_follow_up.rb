class ChoiceFollowUp < FollowUp
  validates :response, presence: true
  validates :rank, presence: true
  validates :rank, inclusion: { in: (1..26) }

  def activated?(message)
    Bot::ChoiceAnswer.new(self).activated?(message)
  end

  def numbers_to_choices
    Hash[(1..26).zip(:a..:z)]
  end

  def choice
    numbers_to_choices[rank]
  end
end
