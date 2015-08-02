class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name
      t.float :salary
      t.integer :shift
      t.datetime :posted_at
      t.belongs_to :programmer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
