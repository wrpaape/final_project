class Senior < Programmer
  has_many :juniors
  has_one :work_task, class_name: "Task", foreign_key: "senior_id"
  has_one :work_project, through: :work_task, class_name: "Project", foreign_key: "senior_id"
  has_one :executive, through: :work_tasks, source: :assigner, source_type: "Executive"
  belongs_to :executive
end
