class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.float :revenue

      t.timestamps null: false
    end
  end
end