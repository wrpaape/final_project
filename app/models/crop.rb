class Crop < ActiveRecord::Base
  has_many :contracts
  has_many :fields
  has_many :farms, through: :fields
end
