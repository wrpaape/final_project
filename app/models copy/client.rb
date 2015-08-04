class Client < ActiveRecord::Base
  extend HandleData

  has_many :contracts
  has_many :farmers, through: :contracts
  def self.get_model_file
"""
class $~Client$ < ActiveRecord::Base
  $#has_many$ $&:contracts$
  $#has_many$ $&:farmers$, $#through:$ $&:contracts$
end
"""
  end

  def self.get_migration_file
"""
class CreateClients < ActiveRecord::Migration
  def change
    $#create_table$ $@:clients$ do |t|
      t$`.string$ $*:name$
      t$`.float$ $*:revenue$

      t$#.timestamps$ $#null:$ $`false$
    end
  end
end
"""
  end
end
