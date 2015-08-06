class Community < ActiveRecord::Base
  has_many :projects, as: :manager
  has_many :tasks, as: :assigner, class_name: "Task"
  alias_attribute :tasks, :tasks_assigned
  has_many :active_members, -> { uniq }, through: :tasks, source: :programmer
  has_and_belongs_to_many :members, -> { uniq }, class_name: "Programmer"
  has_many :languages, -> { uniq }, through: :members
end
