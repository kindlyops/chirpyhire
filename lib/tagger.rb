class Tagger
  def self.call(contact, answer)
    new(contact, answer).call
  end

  attr_reader :contact, :answer

  def initialize(contact, answer)
    @contact = contact
    @answer = answer
  end

  def call
    tag = fetch_tag(answer)
    return if tag.blank?
    contact.taggings.find_or_create_by(tag: tag)
  end

  private

  def fetch_tag(answer)
    category = answer.keys.first
    return if category == :zipcode
    attribute = "Contact::#{category.to_s.camelcase}".constantize
    answer_value = answer.values.first
    name = attribute.new(contact).tag_attribute(answer_value)
    organization.tags.find_or_create_by(name: name)
  end

  delegate :organization, to: :contact
end
