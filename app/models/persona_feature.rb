class PersonaFeature < ActiveRecord::Base
  belongs_to :candidate_persona
  has_many :candidate_features

  validates :format, inclusion: { in: %w(document address choice) }

  def self.next_for(candidate)
    where.not(id: candidate.features.pluck(:persona_feature_id)).first
  end

  def question
    questions[format.to_sym]
  end

  private

  def choice_options_list
    properties['choice_options'].each_with_object("") do |(letter, option), result|
      result << "#{letter}) #{option}\n"
    end
  end

  def choice_options_letters
    properties['choice_options'].keys.to_sentence(last_word_connector: ", or ", two_words_connector: " or ")
  end

  def choice_template
    return "" unless properties['choice_options'].present?
    <<-template
What is your #{name.downcase}?

#{choice_options_list}

Please reply with just the letter #{choice_options_letters}.
template
  end

  def questions
    {
      document: "Please send a photo of your #{name}",
      address: "What is your street address and zipcode?",
      choice: choice_template
    }
  end
end
