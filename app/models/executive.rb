class Executive < Programmer
  include Superior

  has_many :seniors
  has_many :work_projects, as: :manager, class_name: "Project"
end
