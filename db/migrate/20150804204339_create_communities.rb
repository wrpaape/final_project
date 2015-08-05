class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.date :founded_on

      t.timestamps null: false
    end
  end
end
