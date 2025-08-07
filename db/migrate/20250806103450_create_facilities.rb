class CreateFacilities < ActiveRecord::Migration[7.2]
  def change
    create_table :facilities do |t|
      t.string :name
      t.string :official_url
      t.datetime :url_fetched_at

      t.timestamps
    end
  end
end
