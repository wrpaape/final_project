class Farmer < ActiveRecord::Base
  extend HandleData

  has_many :contracts
  has_many :clients, through: :contracts
  has_one :farm

  def self.get_model_file
"""
class $~Farmer$ < ActiveRecord::Base
  $#has_many$ $&:contracts$
  $#has_many$ $&:clients$, $#through:$ $&:contracts$
  $#has_one$ $&:farm$
end
"""
  end

  def self.get_migration_file
"""
class CreateFarmers < ActiveRecord::Migration
  def change
    $#create_table$ $@:farmers$ do |t|
      t$`.string$ $*:name$

      t$#.timestamps null:$ $`false$
    end
  end
end
"""
  end
end
