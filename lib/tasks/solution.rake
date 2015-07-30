require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("solution_queries.log"))
  # hold [cmd + shift + return] or [ctr + shift + return]
  # to reload your results
  
  def solution
    status = Timeout::timeout(5) do
    Farmer.all.map { |farmer| { name: farmer.name, income: farmer.contracts.sum("price * weight") } }.sort { |obj1, obj2| obj2[:income] <=> obj1[:income] }[Farmer.count / 2][:name]
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end