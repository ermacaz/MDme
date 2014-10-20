#MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# Copyright:: Copyright (c) 2014 MDme

# +AdminsController+ runs on the admins subdomain of mdme.us
class AdminsController < ApplicationController

  before_filter :find_admin, except: [:signin]
  before_filter :require_admin_login, except: :signin

  # Cannot visit signin page when signed in
  def signin
    if admin_signed_in?
        redirect_to admins_path
    end

  end

  # Shows a list of all confirmed appointments for the current day
  def index
    @appointments = Appointment.in_clinic(current_admin).
        today.confirmed.order('appointment_time ASC').load.includes([:patient, :doctor])
  end

  def show
    @active = :administration
  end

  private
    def find_admin
      @admin ||= current_admin
    end
    helper_method :find_admin

end
