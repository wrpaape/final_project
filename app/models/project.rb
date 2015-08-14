class Project < ActiveRecord::Base
  extend HandleData

  has_many :tasks
  has_many :tasks_completed, -> { completed }, class_name: "Task"

  belongs_to :manager, polymorphic: true

  alias_attribute :points, :points_total

  scope :completed, -> { where(id: joins(:tasks_completed).group(:id).having("points_total <= SUM(tasks.points)").select(:id)) }
  scope :incomplete, -> { where.not(id: completed.select(:id)) }
  scope :side, -> { where(manager_type: "Community") }
  scope :work, -> { where(manager_type: "Programmer") }

  validate :subordinates_cant_manage_projects, if: "manager"

  def points_assigned
    tasks.sum(:points)
  end

  def points_unassigned
    points - points_assigned
  end

  def points_completed
    tasks.completed.sum(:points)
  end

  def points_incomplete
    points - points_completed
  end

  def subordinates_cant_manage_projects
    unless [Community, Executive].include?(manager.class)
      errors.add(:manager, "must be Community or Executive!")
    end
  end

  def self.get_model_file
"""
class $~Project$ < ActiveRecord::Base
  $#has_many$ $&:tasks$
  $#has_many$ $&:tasks_completed$, -> { $#completed$ }, $#class_name:$ $~\"Task\"$

  $#belongs_to$ $&:manager$, $#polymorphic:$ $`true$

  $#alias_attribute$ $&:points$, $&:points_total$

  $#scope :completed$, -> { $#where($$*id:$ $#joins($$&:tasks_completed$$#).group($$*:id$$#).having($$?\"points_total <= SUM(tasks.points)\"$$#).select($$*:id$$#))$ }
  $#scope :incomplete$, -> { $#where.not($$*id:$ $#completed.select($$*:id$#))$ }
  $#scope :side$, -> { $#where($$*manager_type:$ $`\"Community\"$$#)$ }
  $#scope :work$, -> { $#where($$*manager_type:$ $`\"Programmer\"$$#)$ }

  $#validate$ $%:subordinates_cant_manage_projects$, $#if:$ \"$&manager$\"

  def $*points_assigned$
    $&tasks$$#.sum($$*:points$$#)$
  end

  def $*points_unassigned$
    $*points$ - $*points_assigned$
  end

  def $*points_completed$
    $&tasks$$#.completed.sum($$*:points$$#)$
  end

  def $*points_incomplete$
    $*points$ - $*points_completed$
  end

  def $%subordinates_cant_manage_projects$
    unless [$~Community$, $~Executive$].include?($&manager$.class)
      errors.add($&:manager$, \"must be Community or Executive!\")
    end
  end
end
"""
  end

  def self.get_migration_file
"""
class CreateProjects < ActiveRecord::Migration
  def change
    $#create_table$ $@:projects$ do |t|
      t$`.integer$ $*:manager_id$
      t$`.string$ $*:manager_type$
      t$`.string$ $*:name$
      t$`.integer$ $*:points_total$, $#default:$ $`0$
      t$`.date$ $*:started_on$, $#null:$ $`false$
  
      t$#.timestamps null:$ $`false$
    end

    $#add_index$ $@:projects$, $*:manager_id$
  end
end
"""
  end
end
