class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_default_model_states(available_models)
    states = {}
    available_models.each do |model|
      states[model] = {
        "limit"=> 10,
        "offset"=> 0,
        "search"=> '',
        "sort"=> '',
        "caseSens"=> '',
        "fuzzy"=> 'on',
      }
    end
    states
  end

  def get_solution_data(solution)
    result_hash = get_output_json(solution)
    time_exec = result_hash["time_exec"]
    query_stats = get_query_stats

    if time_exec >= 1
      time_exec = "#{(time_exec).sigfig_to_s(4)} s"
    else
      time_exec = "#{(time_exec * 1000).sigfig_to_s(4)} ms"
    end

    {
      "result"=> result_hash["result"],
      "timeExecTotal"=> time_exec,
      "timeExecQuery"=> query_stats["time_query"],
      "numQueries"=> query_stats["num_queries"]
    }

  end

  private

  def get_output_json(solution)
    file = File.open("lib/tasks/solution.rake", "w")
    file.write(solution)
    file.close
    output = Open3.capture2e("rake solution").first
    output_json = JSON.parse(output)
  end

  def get_query_stats
    time_total = 0
    line_count = 0
    IO.foreach("log/solution_queries.log") do |line|
      time_total += line.scan(/(?<=\()[^m]*/).first.to_f
      line_count += 1
     end
    File.truncate("log/solution_queries.log", 0)

    if time_total >= 1000
      time_query = "#{(time_total / 1000).sigfig_to_s(4)} s"
    else
      time_query = "#{time_total.sigfig_to_s(4)} ms"
    end
    {
      "time_query"=> time_query,
      "num_queries"=> line_count
    }
  end
end

class Float
  def sigfig_to_s(digits)
    f = sprintf("%.#{digits - 1}e", self).to_f
    i = f.to_i
    (i == f ? i : f).to_s
  end
end
