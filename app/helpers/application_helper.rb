module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def disable_turbolinks_caching
    content_for(:disable_turbolinks_caching) do
      # rubocop:disable Rails/OutputSafety
      raw("<meta name='turbolinks-cache-control' content='no-cache'>")
      # rubocop:enable Rails/OutputSafety
    end
  end
end
