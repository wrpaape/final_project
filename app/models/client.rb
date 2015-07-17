class Client < ActiveRecord::Base
  has_many :contracts
  has_many :farmers, through: :contracts
end
