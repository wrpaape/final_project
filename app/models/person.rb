class Person < ActiveRecord::Base
  has_many :children, class_name: "Person", foreign_key: "mother_id"
  has_many :children, class_name: "Person", foreign_key: "father_id"
  has_one :spouse, class_name: "Person", foreign_key: "spouse_id"

  belongs_to :mother, class_name: "Person"
  belongs_to :father, class_name: "Person"
  belongs_to :spouse, class_name: "Person"
end
