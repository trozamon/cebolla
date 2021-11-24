class AddLineItemRefToHours < ActiveRecord::Migration[6.0]
  def change
    add_reference :hours, :line_item, null: true
  end
end
