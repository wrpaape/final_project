class SolvedProblemsController < ApplicationController
  before_action :set_solved_problem, only: [:show, :edit, :update, :destroy]

  # GET /solved_problems
  # GET /solved_problems.json
  def index
    @solved_problems = SolvedProblem.all
  end

  # GET /solved_problems/1
  # GET /solved_problems/1.json
  def show
  end

  # GET /solved_problems/new
  def new
    @solved_problem = SolvedProblem.new
  end

  # GET /solved_problems/1/edit
  def edit
  end

  # POST /solved_problems
  # POST /solved_problems.json
  def create
    @solved_problem = SolvedProblem.new(solved_problem_params)

    respond_to do |format|
      if @solved_problem.save
        format.html { redirect_to @solved_problem, notice: 'Solved problem was successfully created.' }
        format.json { render :show, status: :created, location: @solved_problem }
      else
        format.html { render :new }
        format.json { render json: @solved_problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solved_problems/1
  # PATCH/PUT /solved_problems/1.json
  def update
    respond_to do |format|
      if @solved_problem.update(solved_problem_params)
        format.html { redirect_to @solved_problem, notice: 'Solved problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @solved_problem }
      else
        format.html { render :edit }
        format.json { render json: @solved_problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solved_problems/1
  # DELETE /solved_problems/1.json
  def destroy
    @solved_problem.destroy
    respond_to do |format|
      format.html { redirect_to solved_problems_url, notice: 'Solved problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solved_problem
      @solved_problem = SolvedProblem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def solved_problem_params
      params.require(:solved_problem).permit(:solution, :sol_char_count, :time_exec_total, :time_query_total, :time_query_min, :time_query_max, :time_query_avg, :num_queries, :user_id, :problem_id)
    end
end
