class Executive < Programmer
  include Superior

  has_many :seniors
  has_many :projects_managed, as: :manager, class_name: "Project"
  validates :executive_id, absence: true
end
