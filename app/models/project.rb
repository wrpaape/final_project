class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :manager, polymorphic: true

  scope :completed, -> { where("points_total <= #{joins(:tasks).merge(Task.completed).sum(:points)}") }
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

  def subordinates_cant_manage_projects
    unless [Community, Executive].include?(manager.class)
      errors.add(:manager, "must be Community or Executive!")
    end
  end
end
