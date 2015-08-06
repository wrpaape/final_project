class Programmer < ActiveRecord::Base
  extend HandleData

  has_many :studies
  has_many :languages, through: :studies
  has_many :tasks
  has_many :projects, -> { uniq }, through: :tasks
  has_many :tasks_received, source: :assigner, source_type: "Programmer", class_name: "Task"
  has_many :side_tasks, source: :assigner, source_type: "Community", class_name: "Task"
  has_many :side_projects, -> { uniq }, through: :side_tasks, source: :project
  has_many :active_communities, -> { uniq }, through: :side_tasks, class_name: "Community", source: :assigner, source_type: "Community"
  has_and_belongs_to_many :communities
end
