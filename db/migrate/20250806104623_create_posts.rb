class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :word
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :area, null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true

      t.timestamps
    end
  end
end
