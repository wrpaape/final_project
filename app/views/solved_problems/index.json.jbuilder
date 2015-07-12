json.array!(@solved_problems) do |solved_problem|
  json.extract! solved_problem, :id, :solution, :sol_char_count, :time_exec_total, :time_query_total, :time_query_min, :time_query_max, :time_query_avg, :num_queries, :user_id, :problem_id
  json.url solved_problem_url(solved_problem, format: :json)
end
