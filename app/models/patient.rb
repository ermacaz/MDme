class Patient < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :last_name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }
  before_save { self.email = email.downcase }

  has_secure_password



end
