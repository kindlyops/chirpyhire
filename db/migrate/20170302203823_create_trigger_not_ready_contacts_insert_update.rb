class CreateTriggerNotReadyContactsInsertUpdate < ActiveRecord::Migration[5.0]
  def up
    if respond_to?(:create_trigger)
      create_trigger("not_ready_contacts_before_insert_update_row_tr", :generated => true, :compatibility => 1).
          on("contacts").
          before(:insert, :update) do
        "new.not_ready_content_tsearch := to_tsvector('pg_catalog.simple', coalesce(new.not_ready_content,''));"
      end
    end
  end

  def down
    if respond_to?(:drop_trigger)
      drop_trigger("not_ready_contacts_before_insert_update_row_tr", "contacts", :generated => true)
    end
  end
end
