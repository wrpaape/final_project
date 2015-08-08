class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.date :joined_on, null: false
      t.belongs_to :community, index: true, foreign_key: true
      t.belongs_to :programmer, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
