class Executive < Programmer
  extend HandleData
  include Superior

  has_many :seniors
  validates :executive_id, absence: true
end
