class RemoveImgUrlFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :img_url, :string
  end
end
