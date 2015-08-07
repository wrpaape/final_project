class Community < ActiveRecord::Base
  has_many :projects, as: :manager
  has_many :tasks, as: :assigner
  has_many :tasks_completed, -> { completed }, as: :assigner, class_name: "Task"
  has_many :active_members, -> { uniq }, through: :tasks, class_name: "Programmer"
  has_many :contributors, -> { uniq }, through: :tasks_completed, source: :receiver
  has_and_belongs_to_many :members, -> { uniq }, class_name: "Programmer"
  has_many :collective_languages, -> { uniq }, through: :members, class_name: "Language"

  alias_attribute :side_projects, :projects
  alias_attribute :projects_managed, :projects
  alias_attribute :side_projects_managed, :projects
  alias_attribute :side_tasks, :tasks
  alias_attribute :tasks_assigned, :tasks
  alias_attribute :side_tasks_assigned, :tasks
  alias_attribute :side_tasks_completed, :tasks_completed
  alias_attribute :programmers, :members
  alias_attribute :active_programmers, :active_members
  alias_attribute :languages, :collective_languages
end
