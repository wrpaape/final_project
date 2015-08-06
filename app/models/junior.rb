class Junior < Programmer
  include Subordinate

  belongs_to :senior
end
