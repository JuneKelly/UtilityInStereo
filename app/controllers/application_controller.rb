class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def check_is_active(user)
    if user.is_active == true &&
    user.account_type == 'trial' && 
    user.trial_expire < DateTime.now
      user.is_active = false
      user.save
      redirect_to plans_path, notice: 
        'Your trial has expired, ' +
        'please consider subscribing to our awesome service!'
    elsif user.is_active == false
      redirect_to account_inactive_path
    end
  end

end
