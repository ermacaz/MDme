# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 3/14/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# +Clinic+ model.  Stores geolocation of clinic obtianed from
# Google's geocode api.  Coordinates will be null if no valid address
# information is supplied
class Clinic < ActiveRecord::Base
  has_and_belongs_to_many :patients
  has_many :appointments
  has_many :admins
  has_many :departments
  has_many :doctors


  validates  :name, presence: true, length: { maximum: 30 }
  validates  :slug, presence: true, uniqueness: true

  before_validation :generate_slug
  before_save :set_location_coordinates

  # Order clinics alphabetically by name
  scope :ordered_name, -> { order(name: :asc) }

  def open_appointment_times(date, doctor)
    times = []
    day = (Date::DAYNAMES[date.wday]).downcase
    if self.send("is_open_#{day}?")
      open_time = Time.zone.parse(self.send("#{day}_open_time"))
      close_time = Time.zone.parse(self.send("#{day}_close_time"))
      cursor = open_time.clone
      taken_appointments = doctor.appointments.given_date(date)
      taken_times = find_taken_times(taken_appointments)
      n = 0
      while cursor < close_time
        e = true
        e = false if taken_times.include?(cursor.strftime('%I:%M %p'))
        times << {
            time: cursor.strftime('%I:%M %p'),  #"HH:MM AM"
            enabled: e,
            selected: false,
            index: n }
        n+= 1
        cursor += self.appointment_time_increment.minutes
      end
    else
      return {error: "Clinic is closed on #{date.strftime('%F')}"}
    end
    times
  end

  def open_appointment_times_day_range(date_start, date_end, doctor, time_of_day)
    date_times = {:dates=>[], :times=>[]}
    (date_start..date_end).each do |date|
      date_times[:dates] << date
      day = (Date::DAYNAMES[date.wday]).downcase
      if self.send("is_open_#{day}?")
        case time_of_day
          when 'Morning'
            open_time = Time.zone.parse(self.send("#{day}_open_time"))
            close_time = Time.zone.parse("11:59AM")
          when 'Afternoon'
            open_time  =  Time.zone.parse("12:00PM")
            close_time = Time.zone.parse(self.send("#{day}_close_time"))
          else
            open_time = Time.zone.parse(self.send("#{day}_open_time"))
            close_time = Time.zone.parse(self.send("#{day}_close_time"))
        end
        cursor = open_time.clone
        taken_appointments = doctor.appointments.given_date(date)
        taken_times = find_taken_times(taken_appointments)
        n = 0
        times = []
        while cursor < close_time
          e = true
          e = false if taken_times.include?(cursor.strftime('%I:%M %p'))
          times << {
              time: cursor.strftime('%I:%M %p'),  #"HH:MM AM"
              enabled: e,
              selected: false,
              index: n }
          n+= 1
          cursor += self.appointment_time_increment.minutes
        end
        date_times[:times] << times
      else
        date_times[:times] << false
      end
    end
    date_times
  end

  # Called on clinic creation
  # Calls google geolocation api for latitude/longitude coordinates of
  # the clinic address.  Grabs NE and SW viewport coordinates for easier
  # google map rendering
  # will not change coordinates if invalid address supplied
  def set_location_coordinates
    address = "#{self.address1}+" +
                        "#{self.address2 unless self.address2.nil?}+" +
                        "#{self.address3 unless self.address3.nil?}+" +
                        ", #{self.city}+" +
                        ", #{self.state unless self.state.nil?}+" +
                        "#{self.country}"
    address.gsub!(' ', '+')
    response = call_google_api_for_location(address)
    json = JSON.parse(response)
    unless json['results'].empty?
      latitude = json['results'][0]['geometry']['location']['lat']
      longitude = json['results'][0]['geometry']['location']['lng']
      ne_latitude  = json['results'][0]['geometry']['viewport']['northeast']['lat']
      ne_longitude = json['results'][0]['geometry']['viewport']['northeast']['lng']
      sw_latitude  = json['results'][0]['geometry']['viewport']['southwest']['lat']
      sw_longitude = json['results'][0]['geometry']['viewport']['southwest']['lng']
      self.latitude     = latitude     unless latitude.nil?
      self.longitude    = longitude    unless longitude.nil?
      self.ne_latitude  = ne_latitude  unless ne_latitude.nil?
      self.ne_longitude = ne_longitude unless ne_longitude.nil?
      self.sw_latitude  = sw_latitude  unless sw_latitude.nil?
      self.sw_longitude = sw_longitude unless sw_longitude.nil?
    end

  end

  # Helper for #set_location_coordinates
  # TODO possibly make the call in a thread
  def call_google_api_for_location(address)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{
                                          address}&key=#{ENV['GOOGLE_API_KEY']}"
    response = HTTParty.get url
    response.body
  end

  # Creates a +slug+ for generating readable url.  Slug is generated from
  # the clinic's name.  Slugs are all lower case and replace whitespace with '-'
  # Duplicate names will add '-n' to the end of the name
  # with n being the number of current duplicates
  # Ex: Three created clinics named 'My Clinic' will return
  # my-clinic, my-clinic-1, my-clinic-2, respectively
  def generate_slug
    if self.slug.blank? || self.slug.nil?
      unless self.name.blank?
        if Clinic.where(slug: name.parameterize).count != 0
          n = 1
          while Clinic.where(slug: "#{name.parameterize}-#{n}").count != 0
            n+= 1
          end
          self.slug = "#{name.parameterize}-#{n}"
        else
          self.slug = name.parameterize
        end
      else
        self.slug = 'no-name-entered'.parameterize
      end
    end
  end

  def mail_address
      name + "\n" + "#{address1} #{address2} #{address3} #{city}, #{state} #{zipcode}"
  end

  # +slug+ used in URL opposed to +id+
  def to_param
    slug
  end

  private
    #given list of appointments, will return times in strftime('%I:%M %p')
    def find_taken_times(taken_appointments)
      times = []
      taken_appointments.find_each do |appt|
        times << appt.appointment_time.strftime('%I:%M %p')
      end
      times
    end
end

