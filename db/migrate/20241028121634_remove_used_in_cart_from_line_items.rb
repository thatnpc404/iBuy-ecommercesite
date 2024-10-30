class RemoveUsedInCartFromLineItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :line_items, :used_in_cart, :boolean
  end
end
