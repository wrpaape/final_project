json.array!(@users) do |user|
  json.extract! user, :id, :name, :password_digest, :admin, :problem_count, :problem_id, :environment_id
  json.url user_url(user, format: :json)
end
