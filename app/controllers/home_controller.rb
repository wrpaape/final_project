class HomeController < ApplicationController
  def home
    @urls = {
      "signOut"=> destroy_user_session_path,
      "enter"=> environments_path
    }
    @logged_in = current_user.nil? ? false : true
    respond_to do |format|
      format.html
      format.json { render json: @logged_in }
    end
  end
end
