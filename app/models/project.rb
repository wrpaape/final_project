class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :manager, polymorphic: true
  scope :completed, -> { where("points_total <= #{joins(:tasks).where('tasks.completed = true').sum(:points)}") }
end
