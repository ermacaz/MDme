require 'spec_helper'

describe "AdministrationPages" do
  subject { page }
  before { switch_to_subdomain('admin') }

  describe 'root signin page' do
    before { visit root_path }

    it { should have_title('Admin Sign In')}
    it { should have_content('Admin Sign In')}

    describe 'signing in' do
      describe 'wih invalid information' do
        before do
          fill_in 'Email', with: 'wrong@example.com'
          fill_in 'Password', with: 'baddpass'
          click_button 'Sign in'
        end
        it { should have_title('Admin Sign In') }
        it { should have_selector('div.alert.alert-danger', text: 'Access Denied')}
      end

      describe 'with valid information' do
        let(:admin) { FactoryGirl.create(:admin) }
        let(:appointment) { FactoryGirl.create(:appointment) }
        let(:doctor) { FactoryGirl.create(:doctor) }
        let(:patient) { FactoryGirl.create(:patient) }

        before do
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          click_button 'Sign in'
        end

        it { should have_title 'Admin Panel'}
        it { should_not have_title 'Admin Sign In'}

        describe 'Admin Index Page' do
          it { should have_content 'Manage Appointments'}
          it { should have_content 'Manage Doctors' }
          it { should have_content 'Manage Patients'}
          it { should have_content "Today's Appointments" }

          describe 'invalid appointment creation' do
            before do
              click_link "Manage Appointments"
              click_link "Add Appointment"
              click_button 'Create'
            end
            it { should have_selector('div.alert.alert-danger', text: 'Error creating appointment') }
            it { should have_title('New Appointment')}
          end

          describe 'invalid appointment creation - date/time' do
            before do
              doctor.save!
              patient.save!
              click_link "Manage Appointments"
              click_link "Add Appointment"
              select(doctor.full_name, from: "doctor_doctor_id")
              select(patient.full_name, from: 'patient_patient_id')
              click_button 'Create'
            end
            it { should have_selector('div.alert.alert-danger', text: 'Error creating appointment') }
            it { should have_title('New Appointment')}
          end

          describe 'create appointment' do
            before do
              doctor.save!
              patient.save!
              click_link "Manage Appointments"
              click_link "Add Appointment"
              fill_in('date_day', with: 3.days.from_now.strftime('%F'))
              select('08 AM', from: 'date_hour')
              select('00', from: 'date_minute')
              select(doctor.full_name, from: "doctor_doctor_id")
              select(patient.full_name, from: 'patient_patient_id')
              fill_in('desc_text', with: 'test')
            end
            describe 'After creating appointment' do
              before { click_button 'Create' }
              it { should have_selector('div.alert.alert-success', text: 'Appointment Created') }
              it { should have_title 'Browse Appointments' }
            end

          end
        end
      end
    end
  end

  describe 'Browse appointments', :js => true do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:appointment) { FactoryGirl.create(:appointment) }
    let(:doctor) { FactoryGirl.create(:doctor) }
    let(:patient) { FactoryGirl.create(:patient) }
    before do
      doctor.save!
      patient.save!
      appointment.save!
      @admin = Admin.create!(email: 'testAdmin@example.com', password: 'foobar', password_confirmation: 'foobar')

      visit root_path
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
      click_button 'Sign in'

      click_link "Manage Appointments"
      fill_in 'appointments_date', with: '2013-11-23'
      click_button 'Submit'
      #wait_until { find('#day_appointments') }

    end

    it { should have_selector('#day_appointments') }
    it { should have_content "Select Date" }

    it { should have_content Doctor.first.full_name }

    describe 'show appointment' do
      before { click_link('0') }
      it { should have_text(appointment.description) }

      describe 'editing appointment' do
        describe 'with invalid information' do
          before do
            click_link('Edit Appointment')
            fill_in 'date_day', with: 3.days.ago.strftime('%F')
            click_button('Update')
          end
          it { should have_selector('div.alert.alert-danger', text: 'Invalid parameters in update') }
          it { should have_title 'Edit Appointment' }
        end
        describe 'with valid information' do
          before  do
            click_link('Edit Appointment')
            fill_in 'desc_text', with: 'updated description'
            click_button('Update')
          end
          it { should have_selector('div.alert.alert-success', text: 'Appointment was successfully updated.') }
          describe 'verify edited appointment' do
            before { visit appointment_path(appointment) }
            it { should have_text('updated description') }
          end
        end

        describe 'delete appointment' do
          before do
            visit edit_appointment_path(appointment)
            click_link 'Delete Appointment'
          end
          it { should have_selector('div.alert.alert-warning', text: 'Appointment deleted') }
            #expect { click_link 'Delete Appointment' }.to change(Appointment, :count).by(-1)

        end
      end
    end
  end
end

