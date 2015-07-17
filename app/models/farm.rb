class Farm < ActiveRecord::Base
  has_many :fields
  has_many :crops, through: :fields
  belongs_to :farmer
end
