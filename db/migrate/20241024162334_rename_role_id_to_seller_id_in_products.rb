class RenameRoleIdToSellerIdInProducts < ActiveRecord::Migration[7.2]
  def change
    rename_column :products, :role_id, :seller_id

  end
end
