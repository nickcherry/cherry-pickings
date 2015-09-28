class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column :title, :string
      t.column :body_markdown, :text
      t.column :body_html, :text
      t.column :published, :boolean, default: false
      t.column :published_at, :datetime
      t.timestamps null: false
    end
  end
end
