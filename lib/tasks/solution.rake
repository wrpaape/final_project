require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("log", "solution_queries.log"))
  def solution
    status = Timeout::timeout(5) do
    unprofitable_client_name = Client.select("clients.*, (SUM(contracts.price * contracts.weight) - revenue) AS profit").joins(:contracts).group(:id).order("profit").take.name
  
    farmers_w_income = Farmer.select("farmers.*, SUM(contracts.price * contracts.weight) AS total_income").joins(:contracts).group(:id).order(:id)
    farms_w_upkeep = Farm.select("farms.*, SUM(fields.upkeep) AS total_upkeep").joins(:fields).group(:id).order(:farmer_id)
  
    farmers_w_income.each_with_index do |farmer, index|
      farm = farms_w_upkeep[index]
      profit = farmer.total_income - farm.total_upkeep - farm.maintenance
      if profit < 0
        unprofitable_farmer_name = farmer.name
        return [unprofitable_client_name, unprofitable_farmer_name]
      end
    end
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end