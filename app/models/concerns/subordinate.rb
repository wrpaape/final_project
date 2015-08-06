module Subordinate
  extend ActiveSupport::Concern

  included do
    has_many :projects_assigned, -> { uniq }, through: :tasks_received, class_name: "Project"
    belongs_to :executive
    def superiors
      Programmer.where(id: [executive_id, senior_id])
    end
  end
end
