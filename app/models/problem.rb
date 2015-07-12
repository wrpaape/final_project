class Problem < ActiveRecord::Base
  has_many :users
  has_many :solved_problems, through: :users
  belongs_to :environment
end
