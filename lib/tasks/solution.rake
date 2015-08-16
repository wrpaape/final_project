require 'timeout'
task :solution => :environment do
  ActiveRecord::Base.logger = Logger.new(Rails.root.join("solution_queries.log"))
  # hold [cmd + shift + return] or [ctr + shift + return]
  # to reload your results
  
  def solution
    status = Timeout::timeout(5) do
    sens_w_counts = Senior.joins(:juniors).select("programmers.*, COUNT(programmers) AS jun_count").group(:id)
    clause_targets = sens_w_counts.order("programmers.executive_id ASC, jun_count DESC").as_json.uniq{ |sen| sen["executive_id"] }
    group_clause = clause_targets.map { |sen| "programmers.executive_id = #{sen["executive_id"]} AND COUNT(programmers) = '#{sen["jun_count"]}'" }.join(" OR ")
    Senior.where(id: sens_w_counts.having(group_clause).order(:executive_id).ids)
    end
  end
  
  start = Time.now
  results = solution
  finish = Time.now
  results_hash = { "results"=> results.as_json(methods: :type), "time_exec"=> finish - start }
  puts results_hash.to_json
end