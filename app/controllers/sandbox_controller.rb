class SandboxController < ApplicationController
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

    # get model from json output
    # Model = Object.const_get(params[:model])
    # sandbox_data = Model.get_data(page_and_length)

    respond_to do |format|
      format.html
      format.json { render json: sandbox_data }
    end
  end

  def inspect
    page_and_length = BabyName.get_page_and_length(params)
    @baby_names= BabyName.get_data(page_and_length)
    respond_to do |format|
      format.html
      format.json { render json: @baby_names }
    end
  end
end
