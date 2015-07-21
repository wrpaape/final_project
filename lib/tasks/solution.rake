require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("log", "solution_queries.log"))
  # hold [cmd + shift + return] or [ctr + shift + return]
  # to reload your results
  
  def solution
    status = Timeout::timeout(5) do
    Person.where(:children_count=> [1, 2]).order(:name)
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end