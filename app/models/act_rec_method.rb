class ActRecMethod < ActiveRecord::Base
  extend HandleData

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

      t$#.timestamps null:$ $`false$
    end
  end
end
"""
  end
end
