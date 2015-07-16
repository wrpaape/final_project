class Contract < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :crop
  belongs_to :client
end
