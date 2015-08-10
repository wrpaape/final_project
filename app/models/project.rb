class Project < ActiveRecord::Base
  extend HandleData

  has_many :tasks
  has_many :tasks_completed, -> { completed }, class_name: "Task"

  belongs_to :manager, polymorphic: true

  alias_attribute :points, :points_total


  scope :incomplete, -> { where.not(id: joins(:tasks_completed).group("projects.id").having("points_total <= SUM(tasks.points)").select(:id)) }
  scope :completed, -> { where(id: joins(:tasks_completed).group("projects.id").having("points_total <= SUM(tasks.points)").select(:id)) }
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
end
