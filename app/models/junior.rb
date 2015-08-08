class Junior < Programmer
  extend HandleData
  include Subordinate

  belongs_to :senior
  validates :senior_id, presence: true
end
