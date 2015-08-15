class Study < ActiveRecord::Base
  extend HandleData

  belongs_to :programmer
  belongs_to :language

  scope :entry, -> { where(aptitude: 0) }
  scope :novice, -> { where("aptitude >= 0 AND aptitude < 2") }
  scope :intermediate, -> { where("aptitude >= 2 AND aptitude < 5") }
  scope :competent, -> { where("aptitude >= 5 AND aptitude < 8") }
  scope :expert, -> { where("aptitude >= 8 AND aptitude < 10") }
  scope :mastered, -> { where(aptitude: 10) }

  validates_uniqueness_of :programmer_id, scope: :language_id
  validates :aptitude, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  def self.get_model_file
"""
class $~Study$ < ActiveRecord::Base
  $#belongs_to$ $&:programmer$
  $#belongs_to$ $&:language$
  
  $#scope :entry$, -> { $#where($$*aptitude:$ $`0$$#)$ }
  $#scope :novice$, -> { $#where($$?\"aptitude >= 0 AND aptitude < 2\"$$#)$ }
  $#scope :intermediate$, -> { $#where($$?\"aptitude >= 2 AND aptitude < 5\"$$#)$ }
  $#scope :competent$, -> { $#where($$?\"aptitude >= 5 AND aptitude < 8\"$$#)$ }
  $#scope :expert$, -> { $#where($$?\"aptitude >= 8 AND aptitude < 10\"$$#)$ }
  $#scope :mastered$, -> { $#where($$*aptitude:$ $`10$$#)$ }
  
  $#validates_uniqueness_of$ $*:programmer_id$, $#scope:$ $*:language_id$
  $#validates$ $*:aptitude$, $#numericality:$ { $#greater_than_or_equal_to:$ $`0$, $#less_than_or_equal_to:$ $`10$ }
end
"""
  end

  def self.get_migration_file
"""
class CreateStudies < ActiveRecord::Migration
  def change
    $#create_table$ $@:studies$ do |t|
      t$`.float$ $*:aptitude$, $#default:$ $`0$
      t$*.belongs_to$ $&:programmer$
      t$*.belongs_to$ $&:language$
  
      t$#.timestamps$ $#null:$ $`false$
    end
  end
end
"""
  end
end
