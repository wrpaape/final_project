json.array!(@contracts) do |contract|
  json.extract! contract, :id, :quantity, :price, :farmer_id, :crop_id, :client_id
  json.url contract_url(contract, format: :json)
end
