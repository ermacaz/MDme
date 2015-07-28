json.patient do
  json.(@patient,
        :id,
        :first_name,
        :last_name,
        :email,
        :home_phone,
        :work_phone,
        :mobile_phone,
        :avatar_medium_url,
        :avatar_thumb_url,
        :social_last_four,
        :birthday,
        :birthday_form_format,
        :location,
        :sex_humanize,
        :city,
        :sex,
        :address1,
        :city,
        :state,
        :zipcode)
end