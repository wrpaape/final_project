module HandleData
  extend ActiveSupport::Concern

  def get_data(url, params, environment_id, page_and_length = get_page_and_length(params))
    model_file = self.get_model_file
    migration_file = self.get_migration_file
    keys = self.column_names

    {
      "pageData"=> page_and_length["page_data"],
      "lengthData"=> page_and_length["length_data"],
      "query"=> page_and_length["query"],
      "modelFile"=> model_file,
      "migrationFile"=> migration_file,
      "keys"=>keys,
      "url"=> url,
      "environmentId"=> environment_id
    }
  end

  private

  def get_page_and_length(params)
    search = params.fetch("search", "")
    sort = params.fetch("sort", "")
    limit = params.fetch("limit", "10").to_i
    offset = params.fetch("offset", "0").to_i
    case_sens = params.fetch("case_sens", "")
    fuzzy = params.fetch("fuzzy", "on")
    query_hash = {}
    query_hash["search"] = {}
    query_hash["sort"] = {}
    query_hash["limit"] = limit
    query_hash["offset"] = offset

    search_pairs = search.split("▓")
    split_query = search_pairs.map do |pair|
      key, value = pair.split("░")
      next unless value
      query_hash["search"][key] = value
      value = value.to_datetime.to_s if value.match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/)
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
      next unless dir
      query_hash["sort"][key] = dir
      "#{key} #{dir}"
    end
    sort_query = split_query.compact.join(", ")
    total_count = self.where(search_query).count
    model_name = self.model_name.human.split(" ").map { |word| word.titleize }.join
    {
      "page_data"=> self.where(search_query).order(sort_query).limit(limit).offset(offset),
      "length_data"=> total_count,
      "query"=> build_query(query_hash, fuzzy, case_sens, total_count, model_name)
    }
  end

  def build_query(query_hash, fuzzy, case_sens, total_count, model_name)
    search_hash = query_hash["search"]
    sort_hash = query_hash["sort"]
    return { "query model-name"=> model_name, "query all"=> ".all" } if search_hash.none? && sort_hash.none? && query_hash["limit"].to_i >= total_count && query_hash["offset"].to_i <= 0

    search_query = ".where" if search_hash.size > 0
    if fuzzy == "on" && case_sens == "on"
      search_hash.each_with_index do |(key, value), i|
        search_query += '("' if i == 0
        if type_of(value) == 'Numeric'
          value = "\"#{value}\".to_datetime.to_s" if ["created_at", "updated_at"].include?(key)
          search_query += "CAST(#{key} AS TEXT) LIKE '%#{value}%'"
        else
          search_query += "#{key} LIKE '%#{value}%'"
        end
        search_query += i == (search_hash.size - 1) ? '")' : " AND "
      end
    elsif fuzzy == "on" && case_sens == ""
      search_hash.each_with_index do |(key, value), i|
        search_query += '("' if i == 0
        if type_of(value) == 'Numeric'
          value = "\"#{value}\".to_datetime.to_s.downcase" if ["created_at", "updated_at"].include?(key)
          search_query += "lower(CAST(#{key} AS TEXT)) LIKE '%#{value}%'"
        else
          search_query += "lower(#{key}) LIKE '%#{value.downcase}%'"
        end
        search_query += i == (search_hash.size - 1) ? '")' : " AND "
      end
    elsif fuzzy == "" && case_sens == "on"
      search_hash.each_with_index do |(key, value), i|
        value = "\"#{value}\".to_datetime" if ["created_at", "updated_at"].include?(key)
        if search_hash.size == 1
          search_query += "(#{key}: #{value})"
        else
          search_query += '({ ' if i == 0
          search_query += "#{key}: #{value}"
          search_query += i == (search_hash.size - 1) ? ' })' : ", "
        end
      end
    else
      sq_hash = {}
      ar_hash = {}
      search_hash.each { |(key, value)| type_of(value) == 'Numeric' ? ar_hash[key] = value : sq_hash[key] = value }
      ar_hash.each_with_index do |(key, value), i|
        value = "\"#{value}\".to_datetime" if ["created_at", "updated_at"].include?(key)
        if ar_hash.size == 1
          search_query += "(#{key}: #{value})"
        else
          search_query += '({ ' if i == 0
          search_query += "#{key}: #{value}"
          search_query += i == (ar_hash.size - 1) ? ' })' : ", "
        end
      end
      sq_hash.each_with_index do |(key, value), i|
        search_query += '.where("' if i == 0
        search_query += "lower(#{key}) = '#{value.downcase}'"
        search_query += i == (sq_hash.size - 1) ? '")' : " AND "
      end
    end

    sort_query = ".order" if sort_hash.size > 0
    sort_hash.each_with_index do |(key, dir), i|
      if sort_hash.size == 1
        sort_query += "(#{key}: :#{dir.downcase})"
      else
        sort_query += '({ ' if i == 0
        sort_query += "#{key}: :#{dir.downcase}"
        sort_query += i == (sort_hash.size - 1) ? ' })' : ", "
      end
    end

    query = {}
    query["query model-name"] = model_name
    query["query search"] = search_query
    query["query sort"] = sort_query

    query["query limit"] = ".limit(#{query_hash["limit"]})" unless query_hash["limit"].to_i >= total_count
    query["query offset"] = ".offset(#{query_hash["offset"]})" unless query_hash["offset"].to_i <= 0
    query
  end


  def type_of(value)
    value.to_s.ord >= 46 && value.to_s.ord <= 57 ? 'Numeric' : 'String'
  end
end
