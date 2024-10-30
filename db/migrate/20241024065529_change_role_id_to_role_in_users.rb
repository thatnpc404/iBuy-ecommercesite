class ChangeRoleIdToRoleInUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :role_id, :integer
    add_column :users, :role, :integer # Adjust the type if you need a different one
  end
end
