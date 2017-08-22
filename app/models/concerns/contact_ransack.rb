require 'active_support/concern'

module ContactRansack
  extend ActiveSupport::Concern

  included do
    ransacker :created_at, type: :date do
      Arel::Nodes::SqlLiteral.new('date(contacts.created_at)')
    end

    ransacker :last_reply_at, type: :date do
      Arel::Nodes::SqlLiteral.new('date(contacts.last_reply_at)')
    end
  end

  class_methods do
    def matches_all_manual_messages(*manual_message_ids)
      where(matches_all_manual_messages_arel(manual_message_ids))
    end

    def matches_all_manual_messages_arel(manual_message_ids)
      enumerator = manual_message_ids.each_with_index

      manual_messages = enumerator.reduce(select_id) do |node, (id, index)|
        match_manual_message(node, id, index)
      end

      arel_table[:id].in(manual_messages)
    end

    def match_manual_message(node, id, index)
      join_table = arel_manual_message_participants_table(index)

      node
        .join(join_table)
        .on(arel_table[:id].eq(join_table[:contact_id]))
        .where(join_table[:manual_message_id].eq(id))
    end

    def arel_manual_message_participants_table(index)
      Arel::Table.new(:manual_message_participants).alias("mmp#{index}")
    end

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
      join_table = arel_taggings_table(index)

      node
        .join(join_table)
        .on(arel_table[:id].eq(join_table[:contact_id]))
        .where(join_table[:tag_id].eq(id))
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
      super + %w[matches_all_tags matches_all_manual_messages]
    end
  end
end
