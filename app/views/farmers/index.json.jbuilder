json.array!(@farmers) do |farmer|
  json.extract! farmer, :id, :name
  json.url farmer_url(farmer, format: :json)
end
