class Crop < ActiveRecord::Base
  extend HandleData

  has_many :contracts
  has_many :fields
  has_many :farms, through: :fields

  def self.get_model_file
"""
class $~Crop$ < ActiveRecord::Base
  $#has_many$ $&:contracts$
  $#has_many$ $&:fields$
  $#has_many$ $&:farms$, $#through:$ $&:fields$
end
"""
  end

  def self.get_migration_file
"""
class CreateCrops < ActiveRecord::Migration
  def change
    create_table $@:crops$ do |t|
      t.string $*:name$
      t.float $*:yield$

      t$*.timestamps$ null: false
    end
  end
end
"""
  end
end
