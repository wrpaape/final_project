json.array!(@fields) do |field|
  json.extract! field, :id, :size, :upkeep, :farm_id, :crop_id
  json.url field_url(field, format: :json)
end
