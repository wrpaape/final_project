require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("solution_queries.log"))
  # hold [cmd + shift + return] or [ctr + shift + return]
  # to reload your results
  
  def solution
    status = Timeout::timeout(5) do
    dad = Person.find_by(name: "Cindy").father
    mom = dad.spouse
    dad.children.order(yob: :desc) << mom << dad
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end