json.array!(@contracts) do |contract|
  json.extract! contract, :id, :weight, :price, :start, :finish, :farmer_id, :crop_id, :client_id
  json.url contract_url(contract, format: :json)
end
