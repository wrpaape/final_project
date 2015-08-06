module Superior
  extend ActiveSupport::Concern

  included do
    has_many :juniors
    has_many :tasks_assigned, as: :assigner, class_name: "Task"
    validates :senior_id, absence: true
    def subordinates
      type == "Executive" ? seniors.merge(juniors) : juniors
    end
  end
end
