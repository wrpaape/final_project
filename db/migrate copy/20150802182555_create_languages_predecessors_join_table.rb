class CreateLanguagesPredecessorsJoinTable < ActiveRecord::Migration
  def change
    create_table :languages_predecessors, id: false do |t|
      t.integer :language_id
      t.integer :predecessor_id
    end

    add_index :languages_predecessors, :language_id
    add_index :languages_predecessors, :predecessor_id
  end
end
