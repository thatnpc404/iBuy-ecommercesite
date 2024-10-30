class RemoveShippingAddressFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :shipping_address, :string
  end
end
