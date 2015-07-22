class HomeController < ApplicationController
  def home
    @urls = {
      "signOut"=> destroy_user_session_path,
      "enter"=> environments_path
    }
    @user = current_user
    respond_to do |format|
      format.html
      format.json { render json: current_user }
    end
  end
end
