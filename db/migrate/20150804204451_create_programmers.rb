class CreateProgrammers < ActiveRecord::Migration
  def change
    create_table :programmers do |t|
      t.string :type, default: "Programmer"
      t.string :name
      t.integer :executive_id
      t.integer :senior_id

      t.timestamps null: false
    end
  end
end
