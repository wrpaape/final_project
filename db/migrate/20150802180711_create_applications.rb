class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.datetime :applied_at
      t.belongs_to :programmer, index: true, foreign_key: true
      t.belongs_to :position, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
