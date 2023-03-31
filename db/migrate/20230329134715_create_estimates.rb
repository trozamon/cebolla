class CreateEstimates < ActiveRecord::Migration[6.0]
  def change
    create_table :estimates do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :number, null: false
      t.date :start_date
      t.date :due_date
      t.integer :status, null: false

      t.timestamps
    end

    add_index :estimates, %i[project_id number], unique: true
  end
end
