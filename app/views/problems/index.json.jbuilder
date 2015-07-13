json.array!(@problems) do |problem|
  json.extract! problem, :id, :title, :instructions, :answer, :environment_id
  json.url problem_url(problem, format: :json)
end
