class Users::SessionsController < Devise::SessionsController
#   after_filter :clear_sign_signout_flash, :only => [:create, :destroy]

#   protected

#   def clear_sign_signout_flash
#     if flash.keys.include?(:notice)
#       flash.delete(:notice)
#     end
#   end
# end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
# end
