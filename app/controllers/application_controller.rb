require 'open3'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_up_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end


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
    query_stats = get_query_stats
    time_exec = results_hash["time_exec"] == 'N/A' ? 'N/A' : results_hash["time_exec"] + query_stats.fetch("query_tot_time", 0)
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
    file = File.open(Rails.root.join("lib", "tasks", "solution.rake"), "w")
    file.write(solution)
    file.close
    output = Open3.capture2e("rake solution").first
    error_match = /(?<=^rake aborted!\n)((.|\n)*)/.match(output)
    if output.empty?
      output = { "results"=> "pls call your method after its definition", "time_exec"=> "N/A" }
    elsif error_match.nil?
      output = JSON.parse(output)
      output["results"] = "nil" if output["results"].nil?
      output["results"] = "[]" if output["results"] == []
      output["results"] = "{}" if output["results"] == {}
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
      "query_min_time"=> min_time / 1000,
      "query_max_time"=> max_time / 1000,
      "query_tot_time"=> tot_time / 1000,
      "query_avg_time"=> avg_time / 1000,
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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password) }
  end
end

class Float
  def sigfig_to_s(digits)
    f = sprintf("%.#{digits - 1}e", self).to_f
    i = f.to_i
    (i == f ? i : f).to_s
  end
end
