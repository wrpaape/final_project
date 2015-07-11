module HandleData
  extend ActiveSupport::Concern

  def get_data(url, params, page_and_length = get_page_and_length(params))
    model_file = self.get_model_file
    migration_file = self.get_migration_file

    {
      "pageData"=> page_and_length["page_data"],
      "lengthData"=> page_and_length["length_data"],
      "modelFile"=> model_file,
      "migrationFile"=> migration_file,
      "url"=> url
    }
  end

  private

  def get_page_and_length(params)
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
      value = "%#{value}%" if fuzzy == "on"
      case case_sens
      when "on"
        "CAST(#{key} AS TEXT) LIKE '#{value}'"
      else
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
      "page_data"=> self.where(search_query).order(sort_query).limit(limit).offset(offset),
      "length_data"=> self.where(search_query).count
    }
  end
end
