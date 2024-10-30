class ChangeCartIdNullConstraintInLineItems < ActiveRecord::Migration[7.2]
  def change
    change_column_null :line_items, :cart_id, true
  end
end
