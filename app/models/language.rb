class Language < ActiveRecord::Base
  extend HandleData

  has_and_belongs_to_many :predecessors, class_name: "Language",
                                     join_table: "Language_predecessors",
                                     association_foreign_key: "predecessor_id"
  belongs_to :programmer
  belongs_to :position

  def self.get_model_file
"""
class $~ActRecMethod$ < ActiveRecord::Base
end
"""
  end

  def self.get_migration_file
"""
class CreateActRecMethods < ActiveRecord::Migration
  def change
    $#create_table$ $@:act_rec_methods$ do |t|
      t$`.string$ $*:name$
      t$`.string$ $*:module$
      t$`.string$ $*:syntax$
      t$`.string$ $*:description$
      t$`.text$ $*:example$
      t$`.text$ $*:source$

      t$*.timestamps$ null: false
    end
  end
end
"""
  end
end
