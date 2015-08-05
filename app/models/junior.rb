class Junior < Programmer
  belongs_to :senior
  delegate :executive, to: :senior
  delegate :work_project, to: :senior
  delegate :work_task, to: :senior

  def superiors
    executive << senior
  end
end
