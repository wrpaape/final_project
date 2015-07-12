class User < ActiveRecord::Base
  has_many :solved_problems
  belongs_to :environment
  belongs_to :problem
end
