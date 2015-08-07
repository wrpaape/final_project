class Junior < Programmer
  include Subordinate

  def subordinates
    Programmer.none
  end

  belongs_to :senior
  validates :tasks_assigned, absence: true
end
