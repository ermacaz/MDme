# Author: Matt Hamada
# Copyright MDme 2014
#
# Controller for admin subdomain
#

class AdminsController < ApplicationController

  before_filter :require_admin_login, :except => :signin

  # cannot visit signin page when signed in
  def signin
    if admin_signed_in?
      redirect_to admins_path
    end

  end


  # index page shows a list of all confirmed appointments for the current day
  def index
    @appointments = Appointment.today.confirmed.order('appointment_time ASC').load
  end


end
