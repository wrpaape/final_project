class Junior < Programmer
  extend HandleData
  include Subordinate

  belongs_to :senior

  validates :senior_id, presence: true

  def self.get_model_file
"""
class $~Junior$ < $~Programmer$
  $%include$ $~Subordinate$
  
  $#belongs_to$ $&:senior$
  
  $#validates$ $*:senior_id$, $#presence:$ $`true$
end
"""
  end

  def self.get_migration_file
"""
class CreateProgrammers < ActiveRecord::Migration
  def change
    $#create_table$ $@:programmers$ do |t|
      t$`.string$ $*:type$, $#default:$ $`\"Programmer\"$
      t$`.string$ $*:name$
      t$`.integer$ $*:executive_id$
      t$`.integer$ $*:senior_id$
  
      t$#.timestamps null:$ $`false$
    end
  end
end
"""
  end
end
