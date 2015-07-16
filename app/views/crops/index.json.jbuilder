json.array!(@crops) do |crop|
  json.extract! crop, :id, :name, :yield
  json.url crop_url(crop, format: :json)
end
