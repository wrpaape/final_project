class Junior < Programmer
  include Subordinate

  belongs_to :senior
  def superiors
    Programmer.where(id: [executive_id, senior_id])
  end
end
