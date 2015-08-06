module Subordinate
  extend ActiveSupport::Concern

  included do
    has_many :work_projects, -> { uniq }, through: :received_tasks, source: :assigner, source_type: "Executive", class_name: "Project"
    belongs_to :executive, class_name: "Programmer"
  end
end
