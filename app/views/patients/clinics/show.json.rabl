child @clinic, :object_root => false do
  attributes  :id,
              :name,
              :address1,
              :address2,
              :address3,
              :city,
              :state,
              :country,
              :zipcode,
              :phone_number,
              :fax_number,
              :latitude,
              :longitude,
              :ne_latitude,
              :ne_longitude,
              :sw_latitude,
              :sw_longitude,
              :is_open_sunday,
              :is_open_monday,
              :is_open_tuesday,
              :is_open_wednesday,
              :is_open_thursday,
              :is_open_friday,
              :is_open_saturday,
              :sunday_open_time,
              :sunday_close_time,
              :monday_open_time,
              :monday_close_time,
              :tuesday_open_time,
              :tuesday_close_time,
              :wednesday_open_time,
              :wednesday_close_time,
              :thursday_open_time,
              :thursday_close_time,
              :friday_open_time,
              :friday_close_time,
              :saturday_open_time,
              :saturday_close_time
end

child @doctors, :object_root => false do
attributes :id,
           :full_name,
           :avatar_thumb_url
end