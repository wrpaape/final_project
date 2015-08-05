class Executive < Programmer
  has_many :seniors
  has_many :juniors, through: :seniors
  has_many :projects, as: :manager
  has_many :tasks, as: :assigner

  def subordinates
    seniors << juniors
  end
end
