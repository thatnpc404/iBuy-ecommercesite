class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :price
      t.string :img_url
      t.integer :stock_quantity
      t.integer :role_id
      t.timestamps
    end
  end
end
