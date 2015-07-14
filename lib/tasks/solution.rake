task :solution => :environment do
  Rails.logger = Logger.new("log/solution_queries.log")
  def hello
    
  end
  
  start = Time.now
  results = hello
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end