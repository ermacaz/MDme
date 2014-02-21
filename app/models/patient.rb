# Author: Matt Hamada
# Copyright MDme 2014
#
# Patient model
#


class Patient < ActiveRecord::Base
  include RocketPants::Cacheable #for future API use

  # accept valid email addresses only
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}

  # cannot register multiple users under one email address
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}

  # passwords must be length of 6
  #TODO increase password strength
  validates :password, length: { minimum: 6 }, unless: :is_admin_applying_update

  attr_accessor :is_admin_applying_update

  # emails stored lowercase
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  belongs_to  :doctor
  has_many :appointments

  has_secure_password


  def full_name
    "#{first_name} #{last_name}"
  end


  #TODO refactor session key encryption out of patient model
  def Patient.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Patient.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Patient.encrypt(Patient.new_remember_token)
    end

end
