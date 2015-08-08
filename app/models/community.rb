class Community < ActiveRecord::Base
  extend HandleData

  has_many :projects, as: :manager
  has_many :tasks, as: :assigner
  has_many :completed_tasks, -> { completed }, as: :assigner, class_name: "Task"
  has_many :active_members, -> { uniq }, through: :tasks, class_name: "Programmer"
  has_many :contributors, -> { uniq }, through: :completed_tasks, source: :receiver
  has_many :memberships
  # has_many :founder_memberships, -> { with_founders }, class_name: "Membership"
  has_many :members, through: :memberships, source: :programmer, class_name: "Programmer"
  has_many :founders, -> { founders }, through: :memberships, source: :programmer, class_name: "Programmer"
  has_many :languages, -> { uniq }, through: :members, source: :languages

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

  # def founders
  #   Programmer.where(id: founder_memberships.pluck(:programmer_id))
  # end
end
