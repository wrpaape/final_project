class SandboxController < ApplicationController
  def inspect
    model = Object.const_get(params[:current_model])
    @sandbox_data= model.get_data(params)
    @kata_models = ["BabyName", "Person"]
    respond_to do |format|
      format.html
      format.json { render json: @sandbox_data }
    end
  end

  def interact
    file = File.open("lib/tasks/solution.rake", "w")
    file.write(params[:solution])
    file.close
    output = Open3.capture2e("rake solution").first
    output_json = Array.wrap(JSON.parse(output))
    page_and_length = {
      "pageData": output_json,
      "lengthData": output_json.length
    }

    model = Object.const_get(params[:current_model])
    @sandbox_data = model.get_data(params)

    respond_to do |format|
      format.html
      format.json { render json: @sandbox_data }
    end
  end
end
