object false
extends 'api/v1/success_header'

child :data do
  child @patient, root: 'patient' do
    attributes :first_name, :last_name, :email, :home_phone, :work_phone, :mobile_phone, :avatar_medium_url, :social_last_four
  end
end




