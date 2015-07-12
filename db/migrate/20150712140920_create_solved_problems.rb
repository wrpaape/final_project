class CreateSolvedProblems < ActiveRecord::Migration
  def change
    create_table :solved_problems do |t|
      t.text :solution
      t.integer :sol_char_count
      t.float :time_exec_total
      t.float :time_query_total
      t.float :time_query_min
      t.float :time_query_max
      t.float :time_query_avg
      t.integer :num_queries
      t.belongs_to :user, index: true, foreign_key: true, counter_cache: true
      t.belongs_to :problem, index: true, foreign_key: true, counter_cache: true
      t.belongs_to :environment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
