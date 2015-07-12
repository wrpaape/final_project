class SolvedProblem < ActiveRecord::Base
  belongs_to :environment
  belongs_to :problem
  belongs_to :user
end
