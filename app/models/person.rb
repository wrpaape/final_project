class Person < ActiveRecord::Base
  has_many :children, class_name: "Person", foreign_key: "mother_id"
  has_many :children, class_name: "Person", foreign_key: "father_id"
  has_one :spouse, class_name: "Person", foreign_key: "spouse_id"

  belongs_to :mother, class_name: "Person"
  belongs_to :father, class_name: "Person"
  belongs_to :spouse, class_name: "Person"

  after_create :increment_children_counter_cache
  before_destroy :decrement_children_counter_cache

  private

  def increment_children_counter_cache
    Person.increment_counter('children_count', father.id) if father
    Person.increment_counter('children_count', mother.id) if mother
  end

  def decrement_children_counter_cache
    Person.decrement_counter('children_count', father.id) if father
    Person.decrement_counter('children_count', mother.id) if mother
  end
end
