class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :manager_id
      t.string :manager_type
      t.string :name
      t.integer :points_total, default: 0
      t.date :founded_on

      t.timestamps null: false
    end

    add_index :projects, :manager_id
  end
end
