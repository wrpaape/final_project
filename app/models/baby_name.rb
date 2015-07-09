class BabyName < ActiveRecord::Base
  include HandleData

  def self.get_model_file
"""
class BabyName < ActiveRecord::Base
end
"""
  end

  def self.get_schema_file
"""
create_table \"baby_names\", force: :cascade do |t|
  t.string   \"name\"
  t.string   \"gender\"
  t.integer  \"frequency\"
  t.integer  \"yob\"
  t.datetime \"created_at\", null: false
  t.datetime \"updated_at\", null: false
end
"""
  end
end
