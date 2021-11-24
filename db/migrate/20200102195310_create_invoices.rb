class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :number, null: false
      t.references :entity, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.date :date, null: false
      t.date :due_date, null: false

      t.timestamps
    end
  end
end
