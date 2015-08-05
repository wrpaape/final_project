class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :assigneable, polymorphic: true
end
