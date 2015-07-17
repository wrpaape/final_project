class Farmer < ActiveRecord::Base
  has_many :contracts
  has_many :clients, through: :contracts
  has_one :farm
end
