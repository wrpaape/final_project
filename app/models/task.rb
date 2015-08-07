class Task < ActiveRecord::Base
  belongs_to :assigner, polymorphic: true
  belongs_to :receiver, class_name: "Programmer"
  alias_attribute :programmer, :receiver
  belongs_to :project
  scope :completed, -> { where(completed: true) }
  validate :assigner_has_project, if: "assigner"
  validate :receiver_must_be_subordinate_of_assigner, if: "assigner && receiver && assigner_type == 'Programmer'"
  validate :points_must_be_less_than_or_equal_to_project_points_remaining
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

  def points_must_be_less_than_or_equal_to_project_points_remaining
    unless points <= project.points_remaining
      errors.add(:points, "must be less than or equal to project points remaining!")
    end
  end
end
