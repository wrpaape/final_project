class Contract < ActiveRecord::Base
  extend HandleData

  belongs_to :farmer
  belongs_to :crop
  belongs_to :client

  def self.get_model_file
"""
class $~Contract$ < ActiveRecord::Base
  $#belongs_to$ $&:farmer$
  $#belongs_to$ $&:crop$
  $#belongs_to$ $&:client$
end
"""
  end

  def self.get_migration_file
"""
class CreateContracts < ActiveRecord::Migration
  def change
    create_table $@:contracts$ do |t|
      t.float $*:weight$
      t.float $*:price$
      t.date $*:start$
      t.date $*:finish$
      t$#.belongs_to$ $&:farmer$, index: true, foreign_key: true
      t$#.belongs_to$ $&:crop$, index: true, foreign_key: true
      t$#.belongs_to$ $&:client$, index: true, foreign_key: true

      t$*.timestamps$ null: false
    end
  end
end
"""
  end
end
