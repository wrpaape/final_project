class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :password_confirmation
      t.boolean :admin, default: false
      t.integer :problems_count, default: 0
      t.integer :solved_problems_count, default: 0
      t.integer :environments_cleared, default: 0
      t.belongs_to :problem, index: true, foreign_key: true, counter_cache: true
      t.belongs_to :environment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
