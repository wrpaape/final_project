json.array!(@environments) do |environment|
  json.extract! environment, :id, :title, :description, :models
  json.url environment_url(environment, format: :json)
end
