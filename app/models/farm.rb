class Farm < ActiveRecord::Base
  extend HandleData

  has_many :fields
  has_many :crops, through: :fields
  belongs_to :farmer

  def self.get_model_file
"""
class Farm < ActiveRecord::Base
~~has_many :fields
~~has_many :crops, through: :fields
~~belongs_to :farmer
end
"""
  end

  def self.get_migration_file
"""
class CreateFarms < ActiveRecord::Migration
~~def change
~~~~create_table :farms do |t|
~~~~~~t.float :maintenance
~~~~~~t.belongs_to :farmer, index: true, foreign_key: true

~~~~~~t.timestamps null: false
~~~~end
~~end
end
"""
  end
end
