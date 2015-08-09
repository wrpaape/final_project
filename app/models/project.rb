class Project < ActiveRecord::Base
  has_many :tasks
  has_many :tasks_completed, -> { completed }, class_name: "Task"
  belongs_to :manager, polymorphic: true
  scope :completed_scope, -> { joins(:tasks_completed).group("projects.id").having("points_total <= SUM(tasks.points)") }
  scope :side, -> { where(manager_type: "Community") }
  scope :work, -> { where(manager_type: "Programmer") }

  validate :subordinates_cant_manage_projects, if: "manager"

  alias_attribute :points, :points_total

  def points_assigned
    tasks.sum(:points)
  end

  def points_unassigned
    points - points_assigned
  end

  def points_completed
    tasks.completed.sum(:points)
  end

  def points_uncompleted
    points - points_completed
  end

  def self.completed
    Project.class_eval do
      def self.ooga
        count.count
      end
    end
    completed_scope
  end

  def subordinates_cant_manage_projects
    unless [Community, Executive].include?(manager.class)
      errors.add(:manager, "must be Community or Executive!")
    end
  end
end
