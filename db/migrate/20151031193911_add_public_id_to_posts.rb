class AddPublicIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :public_id, :string
    add_index :posts, :public_id
  end
end
