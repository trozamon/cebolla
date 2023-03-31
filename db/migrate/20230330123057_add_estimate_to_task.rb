class AddEstimateToTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :estimate
  end
end
