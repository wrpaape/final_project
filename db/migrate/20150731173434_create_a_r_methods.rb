class CreateARMethods < ActiveRecord::Migration
  def change
    create_table :a_r_methods do |t|
      t.string :syntax
      t.text :example
      t.text :source

      t.timestamps null: false
    end
  end
end
