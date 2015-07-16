class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.float :size
      t.float :upkeep
      t.belongs_to :farm, index: true, foreign_key: true
      t.belongs_to :crop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
