class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true
      t.text :body
      t.attachment :cover
      t.boolean :is_published, default: true

      t.timestamps
    end
  end
end
