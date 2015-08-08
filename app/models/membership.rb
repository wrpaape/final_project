class Membership < ActiveRecord::Base
  belongs_to :community
  belongs_to :programmer
  validates_uniqueness_of :programmer_id, scope: :community_id
  validate :programmer_cant_join_before_community_founded
  validate :first_programmer_must_be_founder
  scope :with_founders, -> { joins(:community).where("founded_on = joined_on") }

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
end
