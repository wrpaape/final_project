class Programmer < ActiveRecord::Base
  extend HandleData

  has_many :studies
  has_many :entry_studies, -> { entry }, class_name: "Study"
  has_many :novice_studies, -> { novice }, class_name: "Study"
  has_many :intermediate_studies, -> { intermediate }, class_name: "Study"
  has_many :competent_studies, -> { competent }, class_name: "Study"
  has_many :expert_studies, -> { expert }, class_name: "Study"
  has_many :mastered_studies, -> { mastered }, class_name: "Study"
  has_many :languages, through: :studies
  has_many :entry_languages, through: :entry_studies, source: :language, class_name: "Language"
  has_many :novice_languages, through: :novice_studies, source: :language, class_name: "Language"
  has_many :intermediate_languages, through: :intermediate_studies, source: :language, class_name: "Language"
  has_many :competent_languages, through: :competent_studies, source: :language, class_name: "Language"
  has_many :expert_languages, through: :expert_studies, source: :language, class_name: "Language"
  has_many :mastered_languages, through: :mastered_studies, source: :language, class_name: "Language"
  has_many :projects_managed, as: :manager, class_name: "Project"
  has_many :side_tasks, -> { where(assigner_type: "Community") }, foreign_key: "receiver_id", class_name: "Task"
  has_many :tasks_assigned, as: :assigner, class_name: "Task"
  has_many :tasks_received, -> { where(assigner_type: "Programmer") }, foreign_key: "receiver_id", class_name: "Task"
  has_many :side_projects, -> { uniq }, through: :side_tasks, source: :project, class_name: "Project"
  has_many :projects_assigned, -> { uniq }, through: :tasks_assigned, source: :project, class_name: "Project"
  has_many :projects_received, -> { uniq }, through: :tasks_received, source: :project, class_name: "Project"
  has_many :communities_involved, -> { uniq }, through: :side_tasks, source: :assigner, source_type: "Community", class_name: "Community"
  has_many :memberships
  has_many :founder_memberships, -> { with_founders }, class_name: "Membership"
  has_many :communities, through: :memberships

  scope :entries, -> { where(id: joins(:entry_languages).ids.uniq) }
  scope :novices, -> { where(id: joins(:novice_languages).ids.uniq) }
  scope :intermediates, -> { where(id: joins(:intermediate_languages).ids.uniq) }
  scope :competents, -> { where(id: joins(:competent_languages).ids.uniq) }
  scope :experts, -> { where(id: joins(:expert_languages).ids.uniq) }
  scope :masters, -> { where(id: joins(:mastered_languages).ids.uniq) }
  scope :employed, -> { where.not(type: "Programmer") }
  scope :unemployed, -> { where(type: "Programmer") }
  scope :founders, -> { joins(memberships: :community).where("communities.founded_on = memberships.joined_on") }

  alias_attribute :work_projects_managed, :projects_managed
  alias_attribute :side_tasks_received, :side_tasks
  alias_attribute :work_tasks_assigned, :tasks_assigned
  alias_attribute :work_tasks_received, :tasks_received
  alias_attribute :side_projects_received, :side_projects
  alias_attribute :work_projects_assigned, :projects_assigned
  alias_attribute :work_projects_received, :projects_received

  validate :type_same_as_class_or_subclass

  def work_tasks
    tasks_assigned << tasks_received
  end

  def tasks
    work_tasks << side_tasks
  end

  def work_projects
    projects_managed << projects_assigned << projects_received
  end

  def projects
    work_projects << side_projects
  end

  module Superior
    extend ActiveSupport::Concern

    included do
      has_many :juniors
      validates :senior_id, absence: true

      def subordinates
        Programmer.where("executive_id = #{id} OR senior_id = #{id}")
      end
    end
  end

  module Subordinate
    extend ActiveSupport::Concern

    included do
      belongs_to :executive
      validates :executive_id, presence: true

      def superiors
        Programmer.where(id: [executive_id, senior_id])
      end
    end
  end

  def type_same_as_class_or_subclass
    type_as_class = type.constantize
    subclasses = self.class.subclasses
    unless is_a?(type_as_class) || subclasses.include?(type_as_class)
      errors.add(:type, "must be same as its class or subclass!")
    end
  end
end
