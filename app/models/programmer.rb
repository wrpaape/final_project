class Programmer < ActiveRecord::Base
  extend HandleData

  has_many :studies
  has_many :languages, through: :studies
  has_many :side_tasks, class_name: "Task", foreign_key: "programmer_id"
  has_many :side_projects, through: :side_tasks, class_name: "Project", foreign_key: "programmer_id"
  has_many :communities, through: :side_tasks, source: :assigner, source_type: "Community"
  has_many :languages, through: :studies
end
