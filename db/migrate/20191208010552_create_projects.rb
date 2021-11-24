class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.monetize :default_hourly_rate, amount: { null: true }, currency: { null: true }
      t.string :name, null: false
      t.date :due_date
      t.integer :billing, null: false

      t.timestamps
    end
  end
end
