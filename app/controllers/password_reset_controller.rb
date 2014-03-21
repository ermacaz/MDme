class PasswordResetController < ApplicationController

  def new

  end

  def create
    email = params[:password_reset][:email]
    if request.subdomain == 'doctors'
      user = Doctor.find_by_email(email)
    elsif request.subdomain == 'www' || request.subdomain.blank?
      user = Patient.find_by_email(email)
    elsif request.subdomain == 'admin'
      user = Admin.find_by_email(email)
    end

    if user
      newpass =  generate_random_password
      if user.update password: newpass, password_confirmation: newpass
        user.send_password_reset_email(newpass)
        flash[:success] = 'An email has been sent containing your new password'
        redirect_to root_path

      else
        flash[:danger] = 'An error has occured'
        redirect_to root_path

      end
    else
      flash[:warning] = 'Invalid email address entered'
      redirect_to forgot_password_path
    end
  end

end
