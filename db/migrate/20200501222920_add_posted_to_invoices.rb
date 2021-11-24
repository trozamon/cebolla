class AddPostedToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :posted_at, :datetime
    Invoice.update_all('posted_at = created_at')
  end
end
