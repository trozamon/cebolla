class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.decimal :quantity, null: false
      t.monetize :unit_amount
      t.string :description, null: false

      t.timestamps
    end
  end
end
