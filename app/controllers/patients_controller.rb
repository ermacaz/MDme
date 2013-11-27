class PatientsController < ApplicationController
  before_filter :require_admin_login, :only => [:new, :destroy, :index]

  def new
    @patient = Patient.new
  end

  def create
    p = patient_params
    p[:password] = 'temppass'
    p[:password_confirmation] = 'temppass'
    p[:doctor_id] = params[:doctor][:doctor_id]
    @patient = Patient.new(p)
    if @patient.save
      flash[:success] = 'Patient Created'
      redirect_to patients_path
    else
      flash.now[:danger] = 'Error Creating Patient'
      render 'new'
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def index
    @patients = Patient.all.reorder("last_name")
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    @patient.is_admin_applying_update = true if request.subdomain == 'admin'
    @patient.attributes = patient_params
    if @patient.save
      flash[:success] = 'Patient Successfully Updated'
      redirect_to patients_path
    else
      flash.now[:danger] = 'Invalid Parameters Entered'
      render 'new'
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy!
    flash[:warning] = 'Patient Deleted'
    redirect_to patients_path
  end



  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :password, :password_confirmation, :doctor_id)
  end
end
