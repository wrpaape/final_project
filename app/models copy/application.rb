class Application < ActiveRecord::Base
  extend HandleData

  belongs_to :applicant, class_name: "Programmer", foreign_key: "applicant_id"
  belongs_to :applied_job, class_name: "Position", foreign_key: "applied_job_id"

  def self.get_model_file
"""
class $~Application$ < ActiveRecord::Base
  $#belongs_to$ $&:applicant$, $#class_name:$ \"$~Programmer$\", $#foreign_key:$ \"$*applicant_id$\"
  $#belongs_to$ $&:applied_job$, $#class_name:$ \"$~Position$\", $#foreign_key:$ \"$*applied_job_id$\"
end
"""
  end

  def self.get_migration_file
"""
class CreateApplications < ActiveRecord::Migration
  def change
    $#create_table$ $@:applications$ do |t|
      t$`.datetime$ $*:applied_at$
      t$#.belongs_to$ $&:programmer$, $#index:$ $`true$, $#foreign_key:$ \"$*applicant_id$\"
      t$#.belongs_to$ $&:position$, $#index:$ $`true$, $#foreign_key:$ \"$*applied_job_id$\"
  
      t$#.timestamps$ $#null:$ $`false$
    end
  end
end
"""
  end
end
