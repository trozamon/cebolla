class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.string :subject, null: false
      t.text :description
      t.integer :kind, null: false
      t.integer :state, null: false
      t.decimal :est_hours

      t.timestamps
    end
  end
end
