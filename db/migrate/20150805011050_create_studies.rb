class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.float :aptitude, default: 0
      t.belongs_to :programmer
      t.belongs_to :language

      t.timestamps null: false
    end
  end
end
