class Membership < ActiveRecord::Base
  extend HandleData

  belongs_to :community
  belongs_to :programmer

  scope :with_founders, -> { joins(:community).where("founded_on = joined_on") }

  validates_uniqueness_of :programmer_id, scope: :community_id
  validate :programmer_cant_join_before_community_founded
  validate :first_programmer_must_be_founder

  private

  def programmer_cant_join_before_community_founded
    if joined_on < community.founded_on
      errors.add(:joined_on, "can't be before Community is founded!")
    end
  end

  def first_programmer_must_be_founder
    if community.members.count.zero? && joined_on > community.founded_on
      errors.add(:joined_on, "must equal Community's founded_on for first Programmer!")
    end
  end

  def self.get_model_file
"""
class $~Membership$ < ActiveRecord::Base
  $#belongs_to$ $&:community$
  $#belongs_to$ $&:programmer$
  
  $#scope$ $#:with_founders$, -> { $#joins($$&:community$$#).where($$?\"founded_on = joined_on\"$$#)$ }

  $#validates_uniqueness_of$ $*:programmer_id$, $#scope:$ $*:community_id$
  $#validate$ $%:programmer_cant_join_before_community_founded$
  $#validate$ $%:first_programmer_must_be_founder$

  private

  def $%programmer_cant_join_before_community_founded$
    if $*joined_on$ < $&community$$*.founded_on$
      errors.add($*:joined_on$, \"can't be before Community is founded!\")
    end
  end

  def $%first_programmer_must_be_founder$
    if $&community.members$$#.count$.zero? && $*joined_on$ > $&community$$*.founded_on$
      errors.add($*:joined_on$, \"must equal Community's founded_on for first Programmer!\")
    end
  end
end
"""
  end

  def self.get_migration_file
"""
class CreateMemberships < ActiveRecord::Migration
  def change
    $#create_table$ $@:memberships$ do |t|
      t$`.date$ $*:joined_on$, $#null:$ $`false$
      t$#.belongs_to$ $&:community$, $#index:$ $`true$, $#foreign_key:$ $`true$
      t$#.belongs_to$ $&:programmer$, $#index:$ $`true$, $#foreign_key:$ $`true$, $#null:$ $`false$
  
      t$#.timestamps$ $#null:$ $`false$
    end
  end
end

"""
  end
end
