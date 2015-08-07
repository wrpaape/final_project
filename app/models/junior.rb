class Junior < Programmer
  include Subordinate

  def subordinates
    Programmer.none
  end
end
