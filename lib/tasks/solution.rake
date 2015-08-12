require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("solution_queries.log"))
  # hold [cmd + shift + return] or [ctr + shift + return]
  # to reload your results
  
  def solution
    status = Timeout::timeout(5) do
      most_productive_com = Community.joins(:completed_projects).select("communities.*, CAST(COUNT(projects) AS float) / CAST((SELECT COUNT (id) FROM projects WHERE manager_type = 'Community' AND manager_id = communities.id) AS float) as comp_ratio").group(:id).order("comp_ratio DESC").take
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results, "time_exec"=> finish - start }
  puts results_hash.to_json
end