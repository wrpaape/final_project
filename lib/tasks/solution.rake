ActiveRecord::Base.logger = Logger.new(Rails.root.join("solution_queries.log"))
# hold [cmd + shift + return] or [ctr + shift + return]
# to reload your results

def solution
  status = Timeout::timeout(5) do
  Person.takasdfase
  end
end

start = Time.now
results = solution
finish = Time.now
{ "results"=> results.as_json(methods: :type), "time_exec"=> finish - start }
