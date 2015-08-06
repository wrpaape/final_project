class Junior < Programmer
  include Subordinate

  belongs_to :senior
  def superiors
    executive << senior
  end
end
