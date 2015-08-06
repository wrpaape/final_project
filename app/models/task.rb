class Task < ActiveRecord::Base
  belongs_to :assigner, polymorphic: true
  belongs_to :receiver, class_name: "Programmer"
  belongs_to :project
end
