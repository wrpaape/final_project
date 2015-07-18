class Field < ActiveRecord::Base
  extend HandleData

  belongs_to :farm
  belongs_to :crop

  def self.get_model_file
"""
class Field < ActiveRecord::Base
~~belongs_to :farm
~~belongs_to :crop
end
"""
  end

  def self.get_migration_file
"""
class CreateFields < ActiveRecord::Migration
~~def change
~~~~create_table :fields do |t|
~~~~t.float :size
~~~~t.float :upkeep
~~~~t.belongs_to :farm, index: true, foreign_key: true
~~~~t.belongs_to :crop, index: true, foreign_key: true

~~~~t.timestamps null: false
~~end
end
"""
  end
end
