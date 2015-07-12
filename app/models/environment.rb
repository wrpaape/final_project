class Environment < ActiveRecord::Base
  has_many :problems
  has_many :users, through: :problems
  has_many :solved_problems, through: :problems
end
