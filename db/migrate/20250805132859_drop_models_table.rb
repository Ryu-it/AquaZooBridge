class DropModelsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :models
  end
end
