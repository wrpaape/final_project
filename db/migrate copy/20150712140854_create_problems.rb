class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :instructions
      t.text :answer
      t.integer :solved_problems_count, default: 0
      t.integer :users_count, default: 0
      t.belongs_to :environment, index: true, foreign_key: true, counter_cache: true

      t.timestamps null: false
    end
  end
end
