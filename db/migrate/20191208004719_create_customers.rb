class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :email
      t.monetize :default_hourly_rate, amount: { null: true }, currency: { null: true }

      t.timestamps
    end
  end
end
