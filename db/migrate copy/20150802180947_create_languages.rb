class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.integer :yoc
      t.string :creator
      t.belongs_to :programmer, index: true, foreign_key: true
      t.belongs_to :position, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
