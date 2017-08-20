require 'active_support/concern'

module ContactRansack
  extend ActiveSupport::Concern

  class_methods do
    def matches_all_tags(*tag_ids)
      where(matches_all_tags_arel(tag_ids))
    end

    def matches_all_tags_arel(tag_ids)
      enumerator = tag_ids.each_with_index

      tags = enumerator.reduce(select_id) do |node, (id, index)|
        match_tag(node, id, index)
      end

      arel_table[:id].in(tags)
    end

    def match_tag(node, id, index)
      node
        .join(arel_taggings_table(index))
        .on(arel_table[:id].eq(arel_taggings_table(index)[:contact_id]))
        .where(arel_taggings_table(index)[:tag_id].eq(id))
    end

    def arel_taggings_table(index)
      Arel::Table.new(:taggings).alias("t#{index}")
    end

    def select_id
      arel_table.project(arel_table[:id])
    end

    def arel_table
      Arel::Table.new(:contacts)
    end

    def ransackable_scopes(auth_object = nil)
      super + %w[matches_all_tags]
    end
  end
end
