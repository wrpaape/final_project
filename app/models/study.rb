class Study < ActiveRecord::Base
  belongs_to :programmer
  belongs_to :language
end
