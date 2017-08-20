require 'active_support/concern'

module ContactFilters
  extend ActiveSupport::Concern

class_methods do
    def campaigns_filter(campaign_ids)
      return current_scope if campaign_ids.blank?

      cs = current_scope
      campaign_ids.each_with_index do |id, index|
        query = campaigns_query(index)
        cs = cs.joins(campaign_join_clause(index)).where(query, id.to_i)
      end

      cs
    end

    def campaign_join_clause(i)
      'JOIN manual_message_participants AS '\
      "mmp#{i} ON mmp#{i}.contact_id = contacts.id"
    end

    def campaigns_query(i)
      "mmp#{i}.manual_message_id = ?"
    end

    def contact_stage_filter(stage_ids)
      return current_scope if stage_ids.blank?

      joins(:stage).where(contact_stages: { id: stage_ids.map(&:to_i) })
    end

    def tag_filter(tag_ids)
      return current_scope if tag_ids.blank?

      ts = current_scope
      tag_ids.each_with_index do |id, index|
        ts = ts.joins(tag_join_clause(index)).where(tags_query(index), id.to_i)
      end

      ts
    end

    def tag_join_clause(i)
      "JOIN taggings AS t#{i} ON t#{i}.contact_id = contacts.id"
    end

    def tags_query(i)
      "t#{i}.tag_id = ?"
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
