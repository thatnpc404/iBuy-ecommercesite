class AddDetailsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :state, :string
    add_column :orders, :city, :string
    add_column :orders, :country, :string
    add_column :orders, :zip_code, :string
    add_column :orders, :shipping_address, :text
  end
end
