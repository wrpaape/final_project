task :solution => :environment do
  Rails.logger = Logger.new("log/solution_queries.log")
  def solution
    Person.first
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end