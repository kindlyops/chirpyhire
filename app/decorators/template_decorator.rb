class TemplateDecorator < Draper::Decorator
  delegate_all

  def info
    {
      welcome: "Welcome the candidate and let them know about the screening process.",
      thank_you: "Let the candidate know you think they might be a good fit. Include a call to action such as calling the office or let them know you'll be reaching out.",
      bad_fit: "This message is sent to candidates when Chirpyhire determines they are a Bad Fit. Let the candidate know and thank them for their interest."
    }[name.parameterize(separator: "_").to_sym]
  end
end
