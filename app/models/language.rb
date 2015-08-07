class Language < ActiveRecord::Base
  extend HandleData

  has_many :studies
  has_many :programmers, through: :studies
  has_and_belongs_to_many :predecessors,
    class_name: "Language",
    join_table: "languages_predecessors",
    association_foreign_key: "predecessor_id"
  scope :unique, -> { where.not(id: joins(:predecessors).ids.uniq) }

  def self.get_model_file
"""
class $~Language$ < ActiveRecord::Base
  $#has_and_belongs_to_many$ $&:predecessors$,
    $#class_name:$ \"$~Language$\",
    join_table: \"$@languages_predecessors$\",
    association_$#foreign_key:$ \"$*predecessor_id$\"
end
"""
  end

  def self.get_migration_file
"""
class CreateLanguages < ActiveRecord::Migration
  def change
    $#create_table$ $@:languages$ do |t|
      t$`.string$ $*:name$
      t$`.integer$ $*:yoc$
      t$`.string$ $*:creator$

      t$#.timestamps$ $#null:$ $`false$
    end
  end
end

$@# YYYYMMDDHHMMSS_create_languages_predecessors_join_table.rb$

class CreateLanguagesPredecessorsJoinTable < ActiveRecord::Migration
  def change
    $#create_table$ $@:languages_predecessors$, $*id:$ false do |t|
      t$`.integer$ $*:language_id$
      t$`.integer$ $*:predecessor_id$
    end

    $#add_index$ $@:languages_predecessors$, $*:language_id$
    $#add_index$ $@:languages_predecessors$, $*:predecessor_id$
  end
end
"""
  end
end
