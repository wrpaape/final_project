class Task < ActiveRecord::Base
  extend HandleData

  belongs_to :assigner, polymorphic: true
  belongs_to :receiver, class_name: "Programmer"
  belongs_to :project

  alias_attribute :programmer, :receiver

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  validate :assigner_has_project, if: "assigner"
  validate :receiver_must_be_subordinate_of_assigner, if: "assigner && receiver && assigner_type == 'Programmer'"
  validate :cant_be_assigned_before_project_founded_on, if: "assigned_at"
  validate :points_cant_be_greater_than_project_points_remaining
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

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

  def self.get_model_file
"""
class $~Task$ < ActiveRecord::Base
  $#belongs_to$ $&:assigner$, $#polymorphic:$ $`true$
  $#belongs_to$ $&:receiver$, $#class_name:$ $~\"Programmer\"$
  $#belongs_to$ $&:project$

  $#alias_attribute$ $&:programmer$, $&:receiver$

  $#scope$ $#:completed$, -> { $#where($$*completed:$ $`true$$#)$ }
  $#scope$ $#:incomplete$, -> { $#where($$*completed:$ $`false$$#)$ }

  $#validate$ $%:assigner_has_project$, $#if:$ \"$&assigner$\"
  $#validate$ $%:receiver_must_be_subordinate_of_assigner$, $#if:$ \"$&assigner$ && $&receiver$ && $*assigner_type$ == $`'Programmer'$\"
  $#validate$ $%:cant_be_assigned_before_project_founded_on$, $#if:$ \"$*assigned_at$\"
  $#validate$ $%:points_cant_be_greater_than_project_points_remaining$
  $#validates$ $*:points$, $#numericality:$ { $#only_integer:$ $`true$, $#greater_than_or_equal_to:$ $`0$ }

  private

  def $%assigner_has_project$
    unless $&assigner.projects$.include?($&project$)
      errors.add($&:assigner$, \"must have Task's Project!\")
    end
  end

  def $%receiver_must_be_subordinate_of_assigner$
    unless $&assigner.subordinates$.include?($&receiver$)
      errors.add($&:receiver$, \"must be a Subordinate of Assigner!\")
    end
  end

  def $%cant_be_assigned_before_project_founded_on$
    if $*assigned_at$ < $&project$$*.founded_on$
      errors.add($*:assigned_at$, \"must be after Project's founded_on!\")
    end
  end

  def $%points_cant_be_greater_than_project_points_remaining$
    if $*points$ > $&project$$*.points_unassigned$
      errors.add($*:points$, \"can't be greater than Project points remaining!\")
    end
  end
end
"""
  end

  def self.get_migration_file
"""
class CreateTasks < ActiveRecord::Migration
  def change
    $#create_table$ $@:tasks$ do |t|$
      t$`.integer$ $*:assigner_id$
      t$`.string$ $*:assigner_type$
      t$`.string$ $*:description$
      t$`.integer$ $*:points$, $#default:$ $`0$
      t$`.boolean$ $*:completed$, $#default:$ $`false$
      t$`.datetime$ $*:assigned_at$
      t$#.belongs_to$ $&:project$, $#null:$ $`false$
      t$#.belongs_to$ $&:receiver$

      t$#.timestamps$ $#null:$ $`false$
    end
  end
end
"""
  end
end
