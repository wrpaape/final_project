class Programmer < ActiveRecord::Base
  extend HandleData

  def self.get_model_file
"""
class $~BabyName$ < ActiveRecord::Base
end
"""
  end

  def self.get_migration_file
"""
class CreateBabyNames < ActiveRecord::Migration
  def change
    $#create_table$ $@:baby_names$ do |t|
      t$`.string$ $*:name$
      t$`.string$ $*:gender$
      t$`.integer$ $*:frequency$
      t$`.integer$ $*:yob$

      t$*.timestamps$ null: false
    end
  end
end
"""
  end
end
