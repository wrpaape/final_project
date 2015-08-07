class Task < ActiveRecord::Base
  belongs_to :assigner, polymorphic: true
  belongs_to :receiver, class_name: "Programmer"
  belongs_to :project
  scope :completed, -> { where(completed: true) }
  validate :assigner_has_project, :assigner_is_not_junior, if: "assigner"

  def assigner_has_project
    unless assigner.projects.include?(project)
      errors.add(:assigner, "must have task's project!")
    end
  end

  def assigner_is_not_junior
    if assigner.is_a?(Junior)
      errors.add("Juniors can't assign tasks!")
    end
  end
end
