class ChangeOrderIdToAllowNullInLineItems < ActiveRecord::Migration[7.2]
  def change
    change_column_null :line_items, :orders_id, true
  end
end
