class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :title
      t.text :description
      t.string :models
      t.integer :problems_count, default: 0
      t.integer :users_count, default: 0
      t.integer :solved_problems_count, default: 0

      t.timestamps null: false
    end
  end
end
