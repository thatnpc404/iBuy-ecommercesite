class ChangeZipCodeTypeInOrders < ActiveRecord::Migration[7.2]
  def up
    change_column :orders, :zip_code, :integer, using: 'zip_code::integer'
  end

  def down
    change_column :orders, :zip_code, :string
  end
end
