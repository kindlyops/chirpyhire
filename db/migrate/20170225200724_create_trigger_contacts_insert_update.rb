class CreateTriggerContactsInsertUpdate < ActiveRecord::Migration[5.0]
  def up
    if respond_to?(:create_trigger)
      create_trigger("contacts_before_insert_update_row_tr", :generated => true, :compatibility => 1).
          on("contacts").
          before(:insert, :update) do
        "new.content_tsearch := to_tsvector('pg_catalog.simple', coalesce(new.content,''));"
      end
    end
  end

  def down
    if respond_to?(:drop_trigger)
      drop_trigger("contacts_before_insert_update_row_tr", "contacts", :generated => true)
    end
  end
end
