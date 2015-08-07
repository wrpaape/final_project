class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :manager, polymorphic: true
  scope :completed, -> { where("points_total <= #{joins(:tasks).merge(Task.completed).sum(:points)}") }
end
