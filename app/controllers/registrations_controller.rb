class RegistrationsController < Devise::RegistrationsController
  after_filter :clear_flash
  clear_respond_to
  respond_to :json

  protected

  def clear_flash
    flash.delete(:notice) if flash.keys.include?(:notice)
    flash.delete(:alert) if flash.keys.include?(:alert)
  end
end

