module Superior
  extend ActiveSupport::Concern

  included do
    has_many :subordinates, -> { include?(Subordinate) }, class_name: "Programmer"
    has_many :juniors
    has_many :assigned_tasks, as: :assigner, class_name: "Task"
  end
end
