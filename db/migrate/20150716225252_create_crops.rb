class CreateCrops < ActiveRecord::Migration
  def change
    create_table :crops do |t|
      t.string :name
      t.float :yield

      t.timestamps null: false
    end
  end
end
