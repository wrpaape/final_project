class Senior < Programmer
  extend HandleData
  include Superior
  include Subordinate

  def self.get_model_file
"""
class $~Senior$ < $~Programmer$
  $%include$ $~Superior$
  $%include$ $~Subordinate$
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
  
      t$#.timestamps null:$ $`false$
    end
  end
end
"""
  end
end
