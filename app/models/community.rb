class Community < ActiveRecord::Base
  has_many :projects, as: :manager
  alias_attribute :projects, :projects_managed
  has_many :tasks, as: :assigner, class_name: "Task"
  alias_attribute :tasks, :tasks_assigned
  has_many :active_members, -> { uniq }, through: :tasks, class_name: "Programmer"
  has_many :contributors, -> { uniq }, through: :tasks, -> { completed } class_name: "Programmer"
  has_and_belongs_to_many :members, -> { uniq }, class_name: "Programmer"
  has_many :languages, -> { uniq }, through: :members
end
