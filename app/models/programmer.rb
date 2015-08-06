class Programmer < ActiveRecord::Base
  extend HandleData

  has_many :studies
  has_many :languages, through: :studies
  has_many :tasks
  has_many :projects, -> { uniq }, through: :tasks
  has_many :side_tasks, -> { where(assigner_type: "Community") }, foreign_key: "receiver_id", class_name: "Task"
  has_many :side_projects, -> { uniq }, through: :side_tasks, class_name: "Project"
  has_many :active_communities, -> { uniq }, through: :side_tasks, source: :assigner, source_type: "Community", class_name: "Community"
  has_and_belongs_to_many :communities
  validate :type_same_as_class

  module Superior
    extend ActiveSupport::Concern

    included do
      has_many :juniors
      has_many :tasks_assigned, as: :assigner, class_name: "Task"
      validates :senior_id, absence: true
      def subordinates
        type == "Executive" ? seniors << juniors : juniors
      end
    end
  end

  module Subordinate
    extend ActiveSupport::Concern

    included do
      has_many :tasks_received, -> { where(assigner_type: "Programmer") }, foreign_key: "receiver_id", class_name: "Task"
      has_many :projects_received, -> { uniq }, through: :tasks_received, class_name: "Project"
      belongs_to :executive
      def superiors
        Programmer.where(id: [executive_id, senior_id])
      end
    end
  end

  def type_same_as_class
    unless type == self.class.to_s
      errors.add(:type, "type must be same as class")
    end
  end
end
