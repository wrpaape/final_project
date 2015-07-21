require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("log", "solution_queries.log"))
  def solution
    status = Timeout::timeout(5) do
    mike_brady = Person.find_by({name: "Mike", children_count: 6})
    carol_brady = mike_brady.spouse
    brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child|  brady_child }
    if mike_brady.yob > carol_brady.yob
      brady_bunch << mike_brady << carol_brady
    else
      brady_bunch << carol_brady << mike_brady
    end
    brady_bunch
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end