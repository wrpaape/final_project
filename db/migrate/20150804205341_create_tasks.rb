class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :assigner_id
      t.string :assigner_type
      t.string :todo, array: true
      t.integer :points, default: 0
      t.boolean :completed, default: false
      t.datetime :assigned_at
      t.belongs_to :project, null: false
      t.belongs_to :receiver

      t.timestamps null: false
    end
  end
end
