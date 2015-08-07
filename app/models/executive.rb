class Executive < Programmer
  include Superior

  has_many :seniors
  validates :executive_id, absence: true
end
