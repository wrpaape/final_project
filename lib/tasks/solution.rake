task :solution => :environment do
  Rails.logger = Logger.new("log/solution_queries.log")
  def solution
    Person.find(1)
  end
  
  start = Time.now
  result = solution
  finish = Time.now
  result_hash = { "result"=> Array.wrap(result), "time_exec"=> finish - start }
  puts result_hash.to_json
end