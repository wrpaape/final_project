class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_default_model_states(available_models)
    states = {}
    available_models.each do |model, file_name|
      states[model] = {
        "limit"=> 10,
        "offset"=> 0,
        "search"=> '',
        "sort"=> '',
        "caseSens"=> '',
        "fuzzy"=> 'on',
        "fileName"=> file_name
      }
    end
    states
  end

  def get_solution_data(solution)
    result_hash = get_output_json(solution)
    result = result_hash["result"]
    time_exec = result_hash["time_exec"]
    query_stats = get_query_stats

    if time_exec >= 1
      time_exec = "#{(time_exec).sigfig_to_s(4)} s"
    else
      time_exec = "#{(time_exec * 1000).sigfig_to_s(4)} ms"
    end

    {
      "result"=> result,
      "isCorrect"=> result_correct?(result),
      "timeExecTotal"=> time_exec,
      "timeQueryTotal"=> query_stats["query_tot_time"],
      "timeQueryMin"=> query_stats["query_min_time"],
      "timeQueryMax"=> query_stats["query_max_time"],
      "timeQueryAvg"=> query_stats["query_avg_time"],
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
    all_times = []
    IO.foreach("log/solution_queries.log") do |line|
      all_times << line.scan(/(?<=\()[^m]*/).first.to_f
     end
    File.truncate("log/solution_queries.log", 0)
    num_queries = all_times.size
    min_time = all_times.min
    max_time = all_times.max
    tot_time = all_times.inject{ |sum, el| sum + el }
    avg_time = tot_time / num_queries
    query_stats = {
      "query_min_time"=> min_time,
      "query_max_time"=> max_time,
      "query_tot_time"=> tot_time,
      "query_avg_time"=> avg_time,
    }

    query_stats.each do |key, time|
      query_stats[key] = time >= 1000 ? "#{(time / 1000).sigfig_to_s(4)} s" : "#{time.sigfig_to_s(4)} ms"
    end
    query_stats["num_queries"] = num_queries
    query_stats
  end

  def result_correct?(result)
    answer = Array.wrap(Person.find(1))
    parsed_answer = JSON.parse(answer.to_json)
    result == parsed_answer ? true : false
  end
end

class Float
  def sigfig_to_s(digits)
    f = sprintf("%.#{digits - 1}e", self).to_f
    i = f.to_i
    (i == f ? i : f).to_s
  end
end
