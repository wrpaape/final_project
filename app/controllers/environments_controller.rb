require 'open3'
class EnvironmentsController < ApplicationController
  before_action :set_environment, only: :show

  def index
    @environments = get_env_info
  end

  def show
    available_models = JSON.parse(@environment.models)
    model = Object.const_get(params.fetch("current_model", available_models.keys.first))
    # url = "https://active-record-baby.herokuapp.com/environments/#{@environment.id}/"
    url = "/environments/#{@environment.id}/"
    @data= model.get_data(url, params)
    @default_model_states = get_default_model_states(available_models)

    respond_to do |format|
      format.html
      format.json { render json: @data }
    end
  end

  private

  def set_environment
    @environment = Environment.find(params[:id])
  end
end
