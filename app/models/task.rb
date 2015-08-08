class Task < ActiveRecord::Base
  belongs_to :assigner, polymorphic: true
  belongs_to :receiver, class_name: "Programmer"
  alias_attribute :programmer, :receiver
  belongs_to :project
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  validate :assigner_has_project, if: "assigner"
  validate :receiver_must_be_subordinate_of_assigner, if: "assigner && receiver && assigner_type == 'Programmer'"
  validate :cant_be_assigned_before_project_founded_on, if: "assigned_at"
  validate :points_cant_be_greater_than_project_points_remaining
  validates :points,
    numericality:
      {
        only_integer: true,
        greater_than_or_equal_to: 0
      }

  def assigner_has_project
    unless assigner.projects.include?(project)
      errors.add(:assigner, "must have Task's Project!")
    end
  end

  def receiver_must_be_subordinate_of_assigner
    unless assigner.subordinates.include?(receiver)
      errors.add(:receiver, "must be a Subordinate of Assigner!")
    end
  end

  def cant_be_assigned_before_project_founded_on
    if assigned_at < project.founded_on
      errors.add(:assigned_at, "must be after Project's founded_on!")
    end
  end

  def points_cant_be_greater_than_project_points_remaining
    if points > project.points_unassigned
      errors.add(:points, "can't be greater than Project points remaining!")
    end
  end
end
