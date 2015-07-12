json.array!(@problems) do |problem|
  json.extract! problem, :id, :title, :instructions, :answer, :enviroment_id
  json.url problem_url(problem, format: :json)
end
