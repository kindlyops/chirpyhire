class CreateTriggerContactsInsertUpdate < ActiveRecord::Migration[5.0]
  def up
    create_trigger("contacts_before_insert_update_row_tr", :generated => true, :compatibility => 1).
        on("contacts").
        before(:insert, :update) do
      "new.content_tsearch := to_tsvector('pg_catalog.simple', coalesce(new.content,''));"
    end
  end

  def down
    drop_trigger("contacts_before_insert_update_row_tr", "contacts", :generated => true)
  end
end
