class Position < ActiveRecord::Base
  extend HandleData

  has_many :languages
  has_many :applications, foreign_key: "applied_job_id"
  has_many :applicants, through: :applications, class_name: "Programmer", foreign_key: "applied_job_id"
  belongs_to :hire, class_name: "Programmer", foreign_key: "hire_id"

  def self.get_model_file
"""
class $~Position$ < ActiveRecord::Base
  $#has_many$ $&:languages$
  $#has_many$ $&:applications$, $#foreign_key:$ \"$*applied_job_id$\"
  $#has_many$ $&:applicants$, $#through:$ $&:applications$, $#class_name:$ \"$~Programmer$\", $#foreign_key:$ \"$*applied_job_id$\"
  $#belongs_to$ $&:hire$, $#class_name:$ \"$~Programmer$\", $#foreign_key:$ \"$*hire_id$\"
end
"""
  end

  def self.get_migration_file
"""
class CreatePositions < ActiveRecord::Migration
  def change
    $#create_table$ $@:positions$ do |t|
      t$`.string$ $*:name$
      t$`.float$ $*:salary$
      t$`.integer$ $*:shift$
      t$`.datetime$ $*:posted_at$
      t$#.belongs_to$ $&:programmer$, $#index:$ $`true$, $#foreign_key:$ \"$*hire_id$\"
    
      t$#.timestamps$ $#null:$ $`false$
    end
  end
end

"""
  end
end
