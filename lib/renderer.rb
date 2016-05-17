class Renderer
  Recipient = Struct.new(:first_name)
  Organization = Struct.new(:name)

  def self.call(template, user)
    new(template: template, user: user).call
  end

  def call
    Erubis::Eruby.new(erbify_body, pattern: "{{ }}").evaluate(context)
  end

  def initialize(template:, user:)
    @template = template
    @user = user
  end

  private

  attr_reader :user, :template

  def context
    OpenStruct.new(recipient: recipient, organization: organization)
  end

  def erbify_body
    template.body.gsub(/{{/, '{{=')
  end

  def recipient
    Recipient.new(user.first_name)
  end

  def organization
    Organization.new(user.organization_name)
  end
end
