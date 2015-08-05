class Community < ActiveRecord::Base
  has_many :projects, as: :manager
  has_many :tasks, as: :assigner
  has_many :programmers
  has_many :languages, through: :programmers
end
