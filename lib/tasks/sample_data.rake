

namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    #create first doctor and patient and appointment
    Patient.create!(first_name: 'sickly',
                    last_name: 'patient',
                    email: 'user@example.com',
                    password: 'foobar',
                    password_confirmation: 'foobar')
    Doctor.create!(first_name: 'healthy',
                   last_name: 'doctor',
                   email: 'doctor@example.com',
                   password: 'foobar',
                   password_confirmation: 'foobar')
    Appointment.create!(patient_id: 1,
                        doctor_id: 1,
                        appointment_time: Time.now)

    #fill with other sample patients
    60.times do |n|
      name = Faker::Name.name.split(' ')
      email = "examplePatient#{n+1}@example.com"
      password = "password"
      Patient.create!(first_name: name[0],
                      last_name: name[1],
                      email: email,
                      password: password,
                      password_confirmation: password)
    end

    #sample doctors
    6.times do |n|
      name = Faker::Name.name.split(' ')
      email = "exampleDoctor#{n+1}@example.com"
      password = "password"
      Doctor.create!(first_name: name[0],
                     last_name: name[1],
                     email: email,
                     password: password,
                     password_confirmation: password)
    end

    #sample appointments
    60.times do |n|
      patient_id = n+1
      doctor_id = rand_int(1, 7)
      appointment_time = rand_time(3.days.from_now)
      Appointment.create!(patient_id: patient_id,
                          doctor_id: doctor_id,
                          appointment_time: appointment_time)
    end

  end
end

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

def rand_price(from, to)
  rand_in_range(from, to).round(2)
end

def rand_time(endTime, startTime=Time.now)
  Time.at(rand_in_range(startTime.to_f, endTime.to_f))
end

def rand_in_range(from, to)
  rand * (to - from) + from
end