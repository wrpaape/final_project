class CreateActRecMethods < ActiveRecord::Migration
  def change
    create_table :act_rec_methods do |t|
      t.string :name
      t.string :module
      t.string :syntax
      t.text :description
      t.text :example
      t.text :source

      t.timestamps null: false
    end
  end
end
