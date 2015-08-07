class Study < ActiveRecord::Base
  belongs_to :programmer
  belongs_to :language
  scope :novice, -> { where("aptitude < 2") }
  scope :intermediate, -> { where("aptitude >= 2 AND aptitude < 5") }
  scope :advanced, -> { where("aptitude >= 5 AND aptitude < 8") }
  scope :expert, -> { where("aptitude >= 8") }
  validates :aptitude,
    numericality:
      {
        greater_than_or_equal_to: 0,
        less_than_or_equal_to: 10
      }

end
