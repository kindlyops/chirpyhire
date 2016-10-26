class AnswerHandler
  def initialize(sender, inquiry, message)
    @sender = sender
    @inquiry = inquiry
    @message = message
  end

  def call
    if inquiry.unanswered?
      if answer.valid?
        update_or_create_candidate_feature
        AutomatonJob.perform_later(sender, 'answer')
      else
        # TODO JLW 
      end
    end
  end

  private

  attr_reader :inquiry, :sender, :message
  delegate :label, to: :inquiry

  def update_or_create_candidate_feature
    feature = candidate.candidate_features.find_or_initialize_by(label: label)
    feature.properties = extracted_properties
    feature.save
  end

  def extracted_properties
    property_extractor.extract(message, inquiry)
  end

  def answer
    @answer ||= inquiry.create_answer(message: message)
  end

  def candidate
    sender.candidate
  end

  def property_extractor
    AnswerFormatter.new(answer, inquiry).format.constantize
  end
end
