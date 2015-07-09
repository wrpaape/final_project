class BabyName < ActiveRecord::Base

  def self.get_page_and_length(params)
    search = params.fetch("search", "")
    sort = params.fetch("sort", "")
    limit = params.fetch("limit", "10").to_i
    offset = params.fetch("offset", "0").to_i
    case_sens = params.fetch("case_sens", "false")
    fuzzy = params.fetch("fuzzy", "true")

    search_pairs = search.split("▓")
    split_query = search_pairs.map do |pair|
      key, value = pair.split("░")
      next if value.nil?
      value = "%#{value}%" if fuzzy == "true"
      case case_sens
      when "true"
        "CAST(#{key} AS TEXT) LIKE '#{value}'"
      when "false"
        "lower(CAST(#{key} AS TEXT)) LIKE '#{value.downcase}'"
      end
    end
    search_query = split_query.compact.join(" AND ")

    sort_pairs = sort.split("▓")
    split_query = sort_pairs.map do |pair|
      key, dir = pair.split("░")
      next if dir.nil?
      "#{key} #{dir}"
    end
    sort_query = split_query.compact.join(", ")

    {
      "pageData": self.where(search_query).order(sort_query).limit(limit).offset(offset),
      "lengthData": self.where(search_query).count
    }
  end

  def self.get_data(page_and_length)
    model =
"""
class BabyName < ActiveRecord::Base
end
"""
    schema =
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
    keys = BabyName.column_names
    types = keys.map { |key| BabyName.columns_hash[key].type  }

    {
      "pageData": page_and_length[:pageData],
      "lengthData": page_and_length[:lengthData],
      "model": model,
      "schema": schema,
      "keys": keys,
      "types": types,
      "url": "/baby_names/"
    }
  end
end
