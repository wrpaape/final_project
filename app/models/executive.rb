class Executive < Programmer
  extend HandleData
  include Superior

  has_many :seniors

  validates :executive_id, absence: true

  def self.get_model_file
"""
class $~Executive$ < $~Programmer$
  $%include$ $~Superior$
  
  $#has_many$ $&:seniors$
  
  $#validates$ $*:executive_id$, $#absence:$ $`true$
end
"""
  end

  def self.get_migration_file
"""
class CreateProgrammers < ActiveRecord::Migration
  def change
    create_table :programmers do |t|
      t$`.string$ $*:type$, $#default:$ $`\"Programmer\"$
      t$`.string$ $*:name$
      t$`.integer$ $*:executive_id$
      t$`.integer$ $*:senior_id$
  
      t$#.timestamps$ $#null:$ $`false$
    end
  end
end
"""
  end
end
