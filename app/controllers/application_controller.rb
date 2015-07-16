require 'open3'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_default_model_states(available_models)
    states = {}
    available_models.each do |model, file_name|
      states[model] = {
        "limit"=> 5,
        "offset"=> 0,
        "search"=> '',
        "sort"=> '',
        "caseSens"=> 'on',
        "fuzzy"=> '',
        "fileName"=> file_name
      }
    end
    states
  end

  def get_solution_data(params)
    results_hash = get_output_json(params[:solution])
    results = Array.wrap(results_hash["results"])
    time_exec = results_hash["time_exec"]
    query_stats = get_query_stats
    {
      "results"=> results,
      "isCorrect"=> results_correct?(results, params[:problem_id]),
      "timeExecTotal"=> time_exec,
      "timeQueryTotal"=> query_stats.fetch("query_tot_time", "N/A"),
      "timeQueryMin"=> query_stats.fetch("query_min_time", "N/A"),
      "timeQueryMax"=> query_stats.fetch("query_max_time", "N/A"),
      "timeQueryAvg"=> query_stats.fetch("query_avg_time", "N/A"),
      "numQueries"=> query_stats.fetch("num_queries", 0)
    }
  end

  private

  def get_output_json(solution)
    file = File.open(Rails.root.join("lib", "tasks", "solution.rake"), "w"))
    file.write(solution)
    file.close
    output = Open3.capture2e("rake solution").first
    error_match = /(?<=^rake aborted!\n)((.|\n)*)/.match(output)
    if output.empty?
      output = { "results"=> "pls call your method after its definition", "time_exec"=> "N/A" }
    elsif error_match.nil?
      output = JSON.parse(output)
      output["results"] = "nil" if output["results"].nil?
    else
      output = { "results"=> error_match.captures.first.split("\n"), "time_exec"=> "N/A" }
    end

    output
  end

  def get_query_stats
    all_times = []
    log_url = Rails.root.join("log", "solution_queries.log")
    IO.foreach(log_url) do |line|
      all_times << line.scan(/(?<=\()[^m]*/).first.to_f
     end
    File.truncate(log_url, 0)
    num_queries = all_times.size
    return {} if num_queries == 0
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
      query_stats[key] = time
    end
    query_stats["num_queries"] = num_queries
    query_stats
  end

  def results_correct?(results, problem_id)
    answer = Problem.find(problem_id).answer
    parsed_answer = JSON.parse(answer)
    results == parsed_answer ? true : false
  end
end

class Float
  def sigfig_to_s(digits)
    f = sprintf("%.#{digits - 1}e", self).to_f
    i = f.to_i
    (i == f ? i : f).to_s
  end
end
