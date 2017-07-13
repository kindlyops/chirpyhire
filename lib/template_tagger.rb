class TemplateTagger
  def self.call(follow_up, contact, message)
    new(follow_up, contact, message).call
  end

  def initialize(follow_up, contact, message)
    @follow_up = follow_up
    @contact = contact
    @message = message
  end

  attr_reader :follow_up, :contact, :message
  delegate :tags, to: :follow_up

  def call
    tags.find_each(&method(:apply_tag))
  end

  def apply_tag(tag)
    template = Liquid::Template.parse(tag.name)
    templated_tag = org_tags.find_or_create_by(name: parsed_name(template))
    contact.tags << templated_tag
  end

  def parsed_name(template)
    template.render('message' => { 'body' => message.body.strip.downcase })
  end

  def org_tags
    @org_tags ||= contact.organization.tags
  end
end
