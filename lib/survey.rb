class Survey
  def initialize(candidacy)
    @candidacy = candidacy
  end

  def ask
    candidacy.update!(inquiry: inquiry)
    organization.message(recipient: person, body: body)
  end

  private

  def body
    body_after[candidacy.inquiry]
  end

  def inquiry
    inquiry_after[candidacy.inquiry]
  end

  def inquiry_after
    {
      nil => :experience,
      experience: :skin_test,
      skin_test: :availability,
      availability: :transportation,
      transportation: :zipcode,
      zipcode: :cpr_first_aid,
      cpr_first_aid: :certification,
      certification: nil
    }
  end

  def body_after
    {
      nil => experience,
      experience: skin_test,
      skin_test: availability,
      availability: transportation,
      transportation: zipcode,
      zipcode: cpr_first_aid,
      cpr_first_aid: certification,
      certification: thank_you
    }
  end

  def experience
    Question::Experience.new(subscriber).to_s
  end

  def skin_test
    Question::SkinTest.new(subscriber).to_s
  end

  def availability
    Question::Availability.new(subscriber).to_s
  end

  def transportation
    Question::Transportation.new(subscriber).to_s
  end

  def zipcode
    Question::Zipcode.new(subscriber).to_s
  end

  def cpr_first_aid
    Question::CprFirstAid.new(subscriber).to_s
  end

  def certification
    Question::Certification.new(subscriber).to_s
  end

  def thank_you
    Question::ThankYou.new(subscriber).to_s
  end

  attr_reader :candidacy
  delegate :subscriber, to: :candidacy
  delegate :person, :organization, to: :subscriber
end
