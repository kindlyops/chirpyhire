class PersonaFeature < ApplicationRecord
  belongs_to :candidate_persona
  belongs_to :category
  has_many :inquiries

  validates :format, inclusion: { in: %w(document address choice) }
  delegate :template, to: :candidate_persona
  delegate :name, to: :category, prefix: true

  def question
    questions[format.to_sym]
  end

  def inquire(user)
    message = user.receive_message(body: question)
    inquiries.create(message: message)
  end

  def has_geofence?
    properties['distance'].present?
  end

  def uri
    "#{ENV.fetch("ADDRESS_URI_BASE")}/v4/mapbox.emerald/pin-s-marker+000000(#{coordinates.last},#{coordinates.first})/#{coordinates.last},#{coordinates.first},10/300x300@2x.png?access_token=#{ENV.fetch('MAPBOX_ACCESS_TOKEN')}"
  end

  def distance_in_miles
    properties['distance']
  end

  def coordinates
    return [] unless properties['latitude'] && properties['longitude']
    [properties['latitude'], properties['longitude']]
  end

  def has_choices?
    properties['choice_options'].present?
  end

  def choice_options_letters
    properties['choice_options'].keys
  end

  def choice_template
    return "" unless properties['choice_options'].present?
    <<-template
#{text}

#{choice_options_list}

Please reply with just the letter #{choice_options_letters_sentence}.
template
  end

  private

  def choice_options_list
    properties['choice_options'].each_with_object("") do |(letter, option), result|
      result << "#{letter}) #{option}\n"
    end
  end

  def choice_options_letters_sentence
    choice_options_letters.to_sentence(last_word_connector: ", or ", two_words_connector: " or ")
  end

  def questions
    {
      document: text,
      address: text,
      choice: choice_template
    }
  end
end
