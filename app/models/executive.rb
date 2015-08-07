class Executive < Programmer
  include Superior

  validates :executive_id, absence: true

  def superiors
    Programmer.none
  end
end
