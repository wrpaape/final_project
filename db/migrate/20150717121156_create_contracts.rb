class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.float :weight
      t.float :price
      t.date :start
      t.date :finish
      t.belongs_to :farmer, index: true, foreign_key: true
      t.belongs_to :crop, index: true, foreign_key: true
      t.belongs_to :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
