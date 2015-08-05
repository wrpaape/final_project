class Task < ActiveRecord::Base
  belongs_to :assigner, polymorphic: true
  belongs_to :programmer
  belongs_to :project
end
