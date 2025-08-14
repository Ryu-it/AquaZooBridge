class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.bigint :visitor_id, null: false
      t.bigint :visited_id, null: false

      t.string  :notifiable_type, null: false
      t.bigint  :notifiable_id,   null: false

      t.integer :action,  null: false
      t.boolean :checked, null: false, default: false

      t.timestamps
    end

    add_index :notifications, [ :notifiable_type, :notifiable_id ]

    # ここで users テーブルに向けて外部キーを貼る
    add_foreign_key :notifications, :users, column: :visitor_id
    add_foreign_key :notifications, :users, column: :visited_id
  end
end
