class Community < ActiveRecord::Base
  extend HandleData

  has_many :projects, as: :manager
  has_many :incomplete_projects, -> { incomplete }, as: :manager, class_name: "Project"
  has_many :completed_projects, -> { completed }, as: :manager, class_name: "Project"

  has_many :tasks, as: :assigner
  has_many :incomplete_tasks, -> { incomplete }, as: :assigner, class_name: "Task"
  has_many :completed_tasks, -> { completed }, as: :assigner, class_name: "Task"

  has_many :memberships
  has_many :founder_memberships, -> { with_founders }, class_name: "Membership"

  has_many :members, through: :memberships, source: :programmer
  has_many :founders, -> { founders }, through: :memberships, source: :programmer
  has_many :active_members, -> { uniq }, through: :tasks, source: :receiver
  has_many :contributors, -> { uniq }, through: :completed_tasks, source: :receiver

  has_many :languages, -> { uniq }, through: :members

  alias_attribute :side_projects, :projects
  alias_attribute :projects_managed, :projects
  alias_attribute :side_projects_managed, :projects
  alias_attribute :side_tasks, :tasks
  alias_attribute :tasks_assigned, :tasks
  alias_attribute :side_tasks_assigned, :tasks
  alias_attribute :side_completed_tasks, :completed_tasks
  alias_attribute :programmers, :members
  alias_attribute :founder_programmers, :founders
  alias_attribute :active_programmers, :active_members
  alias_attribute :contributing_programmers, :contributors

  def self.get_model_file
"""
class $~Community$ < ActiveRecord::Base
  $#has_many$ $&:projects$, $#as:$ $&:manager$
  $#has_many$ $&:incomplete_projects$, $#as:$ $&:manager&
  $#has_many$ $&:completed_projects$, $#as:$ $&:manager&
   
  $#has_many$ $&:tasks$, $#as:$ $&:assigner$
  $#has_many$ $&:incomplete_tasks$, -> { $#incomplete$ }, $#as:$ $&:assigner$, $#class_name:$ $~\"Task\"$
  $#has_many$ $&:completed_tasks$, -> { $#completed$ }, $#as:$ $&:assigner$, $#class_name:$ $~\"Task\"$
  
  $#has_many$ $&:memberships$
  $#has_many$ $&:founder_memberships$, -> { $#with_founders$ }, $#class_name:$ $~\"Membership\"$
  
  $#has_many$ $&:members$, $#through:$ $&:memberships$, $#source:$ $&:programmer$
  $#has_many$ $&:founders$, -> { $#founders$ }, $#through:$ $&:memberships$, $#source:$ $&:programmer$
  $#has_many$ $&:active_members$, -> { $#uniq$ }, $#through:$ $&:tasks$, $#source:$ $&:programmer$
  $#has_many$ $&:contributors$, -> { $#uniq$ }, $#through:$ $&:completed_tasks$, $#source:$ $&:receiver$
  
  $#has_many$ $&:languages$, -> { $#uniq$ }, $#through:$ $&:members$
  
  $#alias_attribute$ $&:side_projects$, $&:projects$
  $#alias_attribute$ $&:projects_managed$, $&:projects$
  $#alias_attribute$ $&:side_projects_managed$, $&:projects$
  $#alias_attribute$ $&:side_tasks$, $&:tasks$
  $#alias_attribute$ $&:tasks_assigned$, $&:tasks$
  $#alias_attribute$ $&:side_tasks_assigned$, $&:tasks$
  $#alias_attribute$ $&:side_completed_tasks$, $&:completed_tasks$
  $#alias_attribute$ $&:programmers$, $&:members$
  $#alias_attribute$ $&:founder_programmers$, $&:founders$
  $#alias_attribute$ $&:active_programmers$, $&:active_members$
  $#alias_attribute$ $&:contributing_programmers$, $&:contributors$
end
"""
  end

  def self.get_migration_file
"""
class CreateCommunities < ActiveRecord::Migration
  def change
    $#create_table$ $@:communities$ do |t|
      t$`.string$ $*:name$
      t$`.date$ $*:founded_on$

      t$#.timestamps null:$ $`false$
    end
  end
end
"""
  end
end
