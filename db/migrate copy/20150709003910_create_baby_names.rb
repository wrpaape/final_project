class CreateBabyNames < ActiveRecord::Migration
  def change
    create_table :baby_names do |t|
      t.string :name
      t.string :gender
      t.integer :frequency
      t.integer :yob

      t.timestamps null: false
    end
  end
end
