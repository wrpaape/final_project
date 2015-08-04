class Programmer < ActiveRecord::Base
  extend HandleData

  has_many :languages
  has_many :applications, foreign_key: "applicant_id"
  has_many :applied_jobs, through: :applications, class_name: "Position", foreign_key: "applicant_id"
  has_many :jobs, class_name: "Position", foreign_key: "hire_id"

  def self.get_model_file
"""
class $~Programmer$ < ActiveRecord::Base
  $#has_many$ $&:languages$
  $#has_many$ $&:applications$, $#foreign_key:$ \"applicant_id\"
  $#has_many$ $&:applied_jobs$, $#through:$ $&:applications$, $#class_name:$ \"$~Position$\", $#foreign_key:$ \"$*applicant_id$\"
  $#has_many$ $&:jobs$, $#class_name:$ \"$~Position$\", $#foreign_key:$ \"$*hire_id$\"
end
"""
  end

  def self.get_migration_file
"""
class CreateProgrammers < ActiveRecord::Migration
  def change
    $#create_table$ $@:programmers$ do |t|
      t$`.string$ $*:name$
  
      t$#.timestamps$ $#null:$ $`false$
    end
  end
end

"""
  end
end
