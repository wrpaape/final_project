class Person < ActiveRecord::Base
  extend HandleData

  has_many :children, class_name: "Person", foreign_key: "mother_id"
  has_many :children, class_name: "Person", foreign_key: "father_id"
  has_one :spouse, class_name: "Person", foreign_key: "spouse_id"

  belongs_to :mother, class_name: "Person"
  belongs_to :father, class_name: "Person"
  belongs_to :spouse, class_name: "Person"

  after_create :increment_children_counter_cache, :set_generation
  before_destroy :decrement_children_counter_cache

  def self.get_model_file
"""
class Person < ActiveRecord::Base
~~has_many :children, class_name: \"Person\", foreign_key: \"mother_id\"
~~has_many :children, class_name: \"Person\", foreign_key: \"father_id\"
~~has_one :spouse, class_name: \"Person\", foreign_key: \"spouse_id\"

~~belongs_to :mother, class_name: \"Person\"
~~belongs_to :father, class_name: \"Person\"
~~belongs_to :spouse, class_name: \"Person\"

~~after_create :increment_children_counter_cache
~~before_destroy :decrement_children_counter_cache

~~private

~~def increment_children_counter_cache
~~~~Person.increment_counter('children_count', father.id) if father
~~~~Person.increment_counter('children_count', mother.id) if mother
~~end

~~def decrement_children_counter_cache
~~~~Person.decrement_counter('children_count', father.id) if father
~~~~Person.decrement_counter('children_count', mother.id) if mother
~~end

~~def set_generation
~~~~return unless (parent = mother || father)
~~~~self.generation = parent.generation + 1
~~~~self.save
~~end
end
"""
  end

  def self.get_migration_file
"""
class CreatePeople < ActiveRecord::Migration
~~def change
~~~~create_table :people do |t|
~~~~~~t.string :name
~~~~~~t.string :gender
~~~~~~t.integer :yob
~~~~~~t.integer :frequency, default: 0
~~~~~~t.integer :generation, default: 0
~~~~~~t.integer :children_count, default: 0

~~~~~~t.references :mother, index: true
~~~~~~t.references :father, index: true
~~~~~~t.references :spouse, index: true

~~~~~~t.timestamps null: false
~~~~end
~~end
end
"""
  end

  private

  def increment_children_counter_cache
    Person.increment_counter('children_count', father.id) if father
    Person.increment_counter('children_count', mother.id) if mother
  end

  def decrement_children_counter_cache
    Person.decrement_counter('children_count', father.id) if father
    Person.decrement_counter('children_count', mother.id) if mother
  end

  def set_generation
    return unless (parent = mother || father)
    self.generation = parent.generation + 1
    self.save
  end
end
