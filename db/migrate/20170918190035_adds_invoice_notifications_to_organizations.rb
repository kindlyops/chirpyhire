class AddsInvoiceNotificationsToOrganizations < ActiveRecord::Migration[5.1]
  def change
    change_table :organizations do |t|
      t.boolean :invoice_notification, default: true
    end
  end
end
