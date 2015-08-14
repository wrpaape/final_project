class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :manager_id
      t.string :manager_type
      t.string :name
      t.integer :points_total, default: 0
      t.date :started_on, null: false

      t.timestamps null: false
    end

    add_index :projects, :manager_id
  end
end
