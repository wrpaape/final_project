class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :gender
      t.integer :yob
      t.integer :frequency, default: 0
      t.integer :generation, default: 0
      t.integer :children_count, default: 0

      t.references :mother, index: true
      t.references :father, index: true
      t.references :spouse, index: true

      t.timestamps null: false
    end
  end
end
