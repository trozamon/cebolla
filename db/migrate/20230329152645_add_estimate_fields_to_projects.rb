class AddEstimateFieldsToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :hours_cap_kind, :integer
    add_column :projects, :hours_cap, :decimal
    add_column :projects, :status, :integer

    Project.update_all(hours_cap_kind: 1) # ad hoc
    change_column_null :projects, :hours_cap_kind, false
    Project.update_all(status: 1) # active
    change_column_null :projects, :status, false
  end
end
