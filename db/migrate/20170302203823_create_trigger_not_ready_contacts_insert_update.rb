class CreateTriggerNotReadyContactsInsertUpdate < ActiveRecord::Migration[5.0]
  def up
    create_trigger("not_ready_contacts_before_insert_update_row_tr", :generated => true, :compatibility => 1).
        on("contacts").
        before(:insert, :update) do
      "new.not_ready_content_tsearch := to_tsvector('pg_catalog.simple', coalesce(new.not_ready_content,''));"
    end
  end

  def down
    drop_trigger("not_ready_contacts_before_insert_update_row_tr", "contacts", :generated => true)
  end
end
