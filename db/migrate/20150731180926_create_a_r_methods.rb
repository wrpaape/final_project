class CreateARMethods < ActiveRecord::Migration
  def change
    create_table :a_r_methods do |t|
      t.string :name
      t.string :module
      t.string :syntax
      t.string :description
      t.text :example
      t.text :source

      t.timestamps null: false
    end
  end
end
