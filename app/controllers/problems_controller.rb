class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
    environment= @problem.environment
    unless params[:interact]
      available_models = JSON.parse(environment.models)
      model = Object.const_get(params.fetch("current_model", available_models.keys.first))
      url = "https://active-record-baby.herokuapp.com/problems/#{@problem.id}/"
      # url = "/problems/#{@problem.id}/"
      @data_inspect = model.get_data(url, params, environment.id)
      @models_inspect = get_default_model_states(available_models)
    end
    unless params[:inspect]
      @data_interact = ["The Results of your 'solution' Method will be Displayed Here.",
               "Hold [CMD + SHIFT + RETURN] or [CTR + SHIFT + RETURN] to reload your results."]
      # @url_interact = "https://active-record-baby.herokuapp.com/problems/#{params[:id]}/"
      @url_interact = "/problems/#{params[:id]}/"
    end
    if params[:inspect]
      render json: @data_inspect
    elsif params[:interact]
      render json: get_solution_data(params)
    end
  end

  # GET /problems/new
  def new
    @problem = Problem.new
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)

    respond_to do |format|
      if @problem.save
        format.html { redirect_to @problem, notice: 'Problem was successfully created.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    @problem.destroy
    respond_to do |format|
      format.html { redirect_to problems_url, notice: 'Problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:title, :instructions, :answer, :environment_id)
    end
end
