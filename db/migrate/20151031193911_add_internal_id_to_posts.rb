class AddInternalIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :internal_id, :string
  end
end
