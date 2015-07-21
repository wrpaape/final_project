class User < ActiveRecord::Base
  attr_accessor :login
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  validates :name,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }
  has_many :solved_problems
  belongs_to :environment
  belongs_to :problem

  def self.find_first_by_auth_conditions(warden_conditions)
    100.times { puts "hello" }
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
