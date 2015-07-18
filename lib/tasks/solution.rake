require 'timeout'
task :solution => :environment do
  Rails.logger = Logger.new(Rails.root.join("log", "solution_queries.log"))
  def solution
    status = Timeout::timeout(5) do
    farmer_w = Farmer.select("farmers.*, SUM(contracts.price * contracts.weight) AS total_income").joins(:contracts).group(:id).order("total_income DESC").offset(Farmer.count / 2).take
    farmer_w.name
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end