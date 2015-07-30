class SolvedProblemsController < ApplicationController
  def new
    post_params = params.permit(:solution, :sol_char_count, :time_exec_total, :time_query_total, :time_query_min, :time_query_max, :time_query_avg, :num_queries, :problem_id)
    post_params[:environment_id] = Problem.find(params[:problem_id]).environment.id
    @solved_problem = current_user.solved_problems.create(post_params)
    redirect_to environments_path
  end
end
