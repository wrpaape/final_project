class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :manager, polymorphic: true
  scope :completed, -> { where("points_total <= #{joins(:tasks).merge(Task.completed).sum(:points)}") }
  validate :subordinates_cant_manage_projects

  alias_attribute :points, :points_total

  def points_assigned
    tasks.sum(:points)
  end

  def points_completed
    tasks.completed.sum(:points)
  end

  def points_remaining
    points_total - points_completed
  end

  def subordinates_cant_manage_projects
    unless [Community, Executive].include?(manager.class)
      errors.add(:manager, "must be Community or Executive!")
    end
  end
end
