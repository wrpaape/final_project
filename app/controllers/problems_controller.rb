class ProblemsController < ApplicationController
  before_action :set_problem

  def show
    environment= @problem.environment
    @logged_in = current_user.nil? ? false : true
    unless params[:interact]
      available_models = JSON.parse(environment.models)
      model = Object.const_get(params.fetch("current_model", available_models.keys.first))
      url = "https://active-record-baby.herokuapp.com/problems/#{@problem.id}/"
      # url = "/problems/#{@problem.id}/"
      @data_inspect = model.get_data(url, params, environment.id)
      @models_inspect = get_default_model_states(available_models)
    end
    unless params[:inspect]
      @data_interact = ["the results of your 'solution' method will be displayed here",
               "hold [cmd + shift + return] or [ctr + shift + return] to reload your results"]
      @url_interact = "https://active-record-baby.herokuapp.com/problems/#{params[:id]}/"
      # @url_interact = "/problems/#{params[:id]}/"
    end
    if params[:inspect]
      render json: @data_inspect
    elsif params[:interact]
      render json: { "newData"=> get_solution_data(params), "loggedIn"=> @logged_in, "newSolvedProblem"=> "https://active-record-baby.herokuapp.com" + new_solved_problem_path }
      # render json: { "newData"=> get_solution_data(params), "loggedIn"=> @logged_in, "newSolvedProblem"=> new_solved_problem_path }
    end
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end
end
