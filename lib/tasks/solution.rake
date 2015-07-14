task :solution => :environment do
  Rails.logger = Logger.new("log/solution_queries.log")
  def solution
    Person.where(spouse_id: nil).where(generation: 3)
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results.to_json, "time_exec"=> finish - start }
  puts results_hash.to_json
end