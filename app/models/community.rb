class Community < ActiveRecord::Base
  has_many :projects, as: :manager
  has_many :tasks, as: :assigner
  has_many :completed_tasks, -> { completed }, as: :assigner, class_name: "Task"
  has_many :active_members, -> { uniq }, through: :tasks, class_name: "Programmer"
  has_many :contributors, -> { uniq }, through: :completed_tasks, source: :receiver
  has_and_belongs_to_many :members, -> { uniq }, class_name: "Programmer"
  has_many :languages, -> { uniq }, through: :members, source: :languages
  has_many :novice_languages, -> { uniq }, through: :members, source: :novice_languages, class_name: "Language"
  has_many :intermediate_languages, -> { uniq }, through: :members, source: :intermediate_languages, class_name: "Language"
  has_many :advanced_languages, -> { uniq }, through: :members, source: :advanced_languages, class_name: "Language"
  has_many :expert_languages, -> { uniq }, through: :members, source: :expert_languages, class_name: "Language"

  alias_attribute :side_projects, :projects
  alias_attribute :projects_managed, :projects
  alias_attribute :side_projects_managed, :projects
  alias_attribute :side_tasks, :tasks
  alias_attribute :tasks_assigned, :tasks
  alias_attribute :side_tasks_assigned, :tasks
  alias_attribute :side_completed_tasks, :completed_tasks
  alias_attribute :programmers, :members
  alias_attribute :active_programmers, :active_members
  alias_attribute :contributing_programmers, :contributors
end
