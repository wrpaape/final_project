class Junior < Programmer
  include Subordinate

  validates :senior_id, presence: true
end
