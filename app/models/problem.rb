class Problem < ActiveRecord::Base
  has_many :solved_problems
  has_many :users, through: :solved_problems
  belongs_to :environment
end
