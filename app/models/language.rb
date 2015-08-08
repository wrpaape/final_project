class Language < ActiveRecord::Base
  extend HandleData

  has_many :studies
  has_many :entry_studies, -> { entry }, class_name: "Study"
  has_many :novice_studies, -> { novice }, class_name: "Study"
  has_many :intermediate_studies, -> { intermediate }, class_name: "Study"
  has_many :competent_studies, -> { competent }, class_name: "Study"
  has_many :expert_studies, -> { expert }, class_name: "Study"
  has_many :mastered_studies, -> { mastered }, class_name: "Study"
  has_many :programmers, through: :studies
  has_many :entries, through: :entry_studies, source: :programmer, class_name: "Programmer"
  has_many :novices, through: :novice_studies, source: :programmer, class_name: "Programmer"
  has_many :intermediates, through: :intermediate_studies, source: :programmer, class_name: "Programmer"
  has_many :competents, through: :competent_studies, source: :programmer, class_name: "Programmer"
  has_many :experts, through: :expert_studies, source: :programmer, class_name: "Programmer"
  has_many :masters, through: :mastered_studies, source: :programmer, class_name: "Programmer"
  has_and_belongs_to_many :predecessors,
    class_name: "Language",
    join_table: "languages_predecessors",
    association_foreign_key: "predecessor_id"

  scope :with_entries, -> { where(id: joins(:entries).ids.uniq) }
  scope :with_novices, -> { where(id: joins(:novices).ids.uniq) }
  scope :with_intermediates, -> { where(id: joins(:intermediates).ids.uniq) }
  scope :with_competents, -> { where(id: joins(:competents).ids.uniq) }
  scope :with_experts, -> { where(id: joins(:experts).ids.uniq) }
  scope :with_masters, -> { where(id: joins(:masters).ids.uniq) }
  scope :studied, -> { where(id: joins(:studies).ids.uniq) }
  scope :unstudied, -> { where.not(id: joins(:studies).ids.uniq) }

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
