class CreateHours < ActiveRecord::Migration[6.0]
  def change
    create_table :hours do |t|
      t.date :date
      t.decimal :num
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
