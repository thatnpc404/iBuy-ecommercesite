class RenameOrdersIdToOrderIdInLineItems < ActiveRecord::Migration[7.2]
  def change
    rename_column :line_items, :orders_id, :order_id
  end
end
