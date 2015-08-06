module Subordinate
  extend ActiveSupport::Concern

  has_many :work_projects, -> { uniq }, through: :received_tasks, class_name: "Project"
  belongs_to :executive
  belongs_to :superiors
end
