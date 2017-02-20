module DeviseHelper
  def devise_error_messages!
    return '' unless devise_error_messages?

    html = <<-HTML
    <div class="alert alert-warning">
      <span>#{messages}</span>
    </div>
    HTML

    # rubocop:disable Rails/OutputSafety
    html.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

  private

  def messages
    resource.errors.full_messages.to_sentence
  end
end
