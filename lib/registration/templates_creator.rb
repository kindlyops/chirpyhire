class Registration::TemplatesCreator
  def initialize(organization)
    @organization = organization
  end

  def create_templates
    create_bad_fit_template
    create_welcome_template
    create_thank_you_template
    create_not_understood_template
  end

  def create_not_understood_template
    @not_understood = organization.templates.create(
      name: 'Not Understood', body: "We didn't quite get that. Please try "\
      'again, or a staff member will get back to you as soon as possible.'
    )
  end

  attr_reader :bad_fit, :welcome, :thank_you, :not_understood

  private

  attr_reader :organization

  def create_bad_fit_template
    @bad_fit = organization.templates.create(
      name: 'Bad Fit',
      body:
        "Thank you very much for your interest. Unfortunately, we don't "\
        'have a good fit for you at this time. If anything changes we will '\
        'let you know.'
    )
  end

  def create_welcome_template
    @welcome = organization.templates.create(
      name: 'Welcome',
      body: "Hello this is #{organization.name}. We're so glad you are "\
      'interested in learning about opportunities here. We have a few '\
      'questions to ask you via text message.'
    )
  end

  def create_thank_you_template
    @thank_you = organization.templates.create(
      name: 'Thank You', body: 'Thanks for your interest!'
    )
  end
end
