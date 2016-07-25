module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def disable_turbolinks_caching
    content_for(:disable_turbolinks_caching) do
      raw("<meta name='turbolinks-cache-control' content='no-cache'>")
    end
  end
end
