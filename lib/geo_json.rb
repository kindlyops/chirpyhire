module GeoJson
  extend ActionView::Helpers::DateHelper

  def self.single_description(candidate, candidate_location_p_tag: nil)
    "<h3>Candidate: <a href='/users/#{candidate.user_id}/messages'>\
      #{candidate.phone_number&.phony_formatted}</a></h3>\
    <p class='handle sub-header'>#{candidate.handle}</p>
    #{candidate_location_p_tag}\
    <p>Created: #{time_ago_in_words(candidate.created_at)} ago</p>"
  end
end
