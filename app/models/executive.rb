class Executive < Programmer
  include Superior

  has_many :seniors
  validates :executive_id, absence: true
  validate :cant_receive_tasks

  def superiors
    Programmer.none
  end

  def cant_receive_tasks
    unless tasks_received.empty?
      errors.add(:tasks_received, "must be empty for Executives!")
    end
  end
end
