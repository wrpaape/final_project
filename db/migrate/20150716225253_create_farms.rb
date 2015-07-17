class CreateFarms < ActiveRecord::Migration
  def change
    create_table :farms do |t|
      t.float :maintenance
      t.belongs_to :farmer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

