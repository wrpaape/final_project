module Superior
  extend ActiveSupport::Concern

  included do
    has_many :juniors
    has_many :assigned_tasks, as: :assigner, class_name: "Task"

    def subordinates
      methods.include?(:seniors) ? seniors.merge(juniors) : juniors
    end
  end
end
