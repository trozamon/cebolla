class CreateEntities < ActiveRecord::Migration[6.0]
  def change
    create_table :entities do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.integer :starting_invoice, default: 1

      t.timestamps
    end
  end
end
