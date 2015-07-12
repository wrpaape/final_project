require 'open3'
class SandboxController < ApplicationController
  def inspect
    available_models = ["BabyName", "Person"]
    model = Object.const_get(params.fetch("current_model", available_models.first))
    url = "/sandbox/inspect/"
    @sandbox_data= model.get_data(url, params)
    @default_model_states = get_default_model_states(available_models)

    respond_to do |format|
      format.html
      format.json { render json: @sandbox_data }
    end
  end

  def kata
    @sandbox_data = Person.limit(20)
  end

  def interact
    render json: get_solution_data(params[:solution])
  end
end
