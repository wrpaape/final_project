class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :gender
      t.integer :yob

      t.references :mother, index: true
      t.references :father, index: true
      t.references :spouse, index: true

      t.timestamps null: false
    end
  end
end
