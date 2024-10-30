class AddStatusToLineItems < ActiveRecord::Migration[7.2]
  def change
    add_column :line_items, :status, :string
  end
end
