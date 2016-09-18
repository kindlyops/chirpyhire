# frozen_string_literal: true
module DeviseHelper
  def devise_error_messages!
    return '' unless devise_error_messages?

    html = <<-HTML
    <div class="error" id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    safe_join([html])
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

  private

  def sentence
    I18n.t('errors.messages.not_saved',
           count: resource.errors.count,
           resource: resource.class.model_name.human.downcase)
  end

  def messages
    resource.errors.full_messages.map do |msg|
      content_tag(:li, msg)
    end.join
  end
end
