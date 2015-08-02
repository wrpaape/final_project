class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.integer :yob
      t.string :creator
      t.belongs_to :programmer, index: true, foreign_key: true
      t.belongs_to :position, index: true, foreign_key: true

      t.timestamps null: false
    end
    create_table :language_predecessors do |t|
      t.integer :language_id
      t.integer :predecessor_id

      t.timestamps null: false
    end
  end
end
