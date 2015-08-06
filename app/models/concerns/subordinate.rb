module Subordinate
  extend ActiveSupport::Concern

  included do
    has_many :work_projects, -> { uniq }, through: :received_tasks, class_name: "Project"
    belongs_to :executive
  end
end
