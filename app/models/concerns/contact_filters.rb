require 'active_support/concern'

module ContactFilters
  extend ActiveSupport::Concern

  class_methods do

    def campaigns_filter(campaign_ids)
      return current_scope if campaign_ids.blank?

      joins(:manual_message_participants)
        .where(manual_message_participants: { 
          manual_message_id: campaign_ids.map(&:to_i) 
        }).group(:id).having('count(*) = ?', campaign_ids.count)
    end

    def campaigns_query
      'manual_message_participants.manual_message_id = ALL (array[?])'
    end

    def contact_stage_filter(stage_ids)
      return current_scope if stage_ids.blank?

      joins(:stage).where(contact_stages: { id: stage_ids.map(&:to_i) })
    end

    def tag_filter(tag_ids)
      return current_scope if tag_ids.blank?

      joins(:tags).where('tags.id = ALL (array[?])', tag_ids.map(&:to_i))
    end

    def messages_filter(count)
      return current_scope if count.blank?

      where(messages_count: count)
    end

    def name_filter(name)
      return current_scope if name.blank?

      search_by_name(name)
    end

    def zipcode_filter(filter_params)
      return current_scope if filter_params.blank?

      filters = filter_params.map do |k, v|
        sanitize_sql_array(["lower(\"zipcodes\".\"#{k}\") = ?", v.downcase])
      end.join(' AND ')

      joins(:zipcode).where(filters)
    end
  end
end
