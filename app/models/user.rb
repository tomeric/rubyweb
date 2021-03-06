require 'digest/sha1'

class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :url

  # validations:
  validates_presence_of :login, :email
  
  validates_format_of   :email,
                        :with    => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :if      => :email?,
                        :message => 'is geen geldig e-mail adres'

  # validations that apply when a password is required:
  with_options :if => :password_required? do |user|
    user.validates_presence_of     :password

    user.validates_presence_of     :password_confirmation

    user.validates_confirmation_of :password

    user.validates_length_of       :password,
                                   :within => 4..40
  end

  # validations that apply when a login is present:
  with_options :if => :login? do |user|
    user.validates_length_of     :login,
                                 :within => 3..40

    user.validates_uniqueness_of :login,
                                 :case_sensitive => false

    user.validates_format_of     :login,
                                 :with => /^\w+$/
  end
  
  # validations that apply when a URL is present:
  with_options :if => :url? do |user|
    user.validates_format_of :url,
                             :with    => URI.regexp,
                             :message => 'is geen geldige <abbr>URL</abbr>, een geldige <abbr>URL</abbr> begint met http://'
  
    user.validates_format_of :url,
                             :with    => /^http(s)?:\/\//,
                             :message => 'is geen geldige <abbr>URL</abbr>, een geldige <abbr>URL</abbr> begint met http://'                             
  end
  
  # callbacks:
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 52.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def reset_password_token
    encrypt(self.login + self.crypted_password)
  end

  protected

  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
    
  def password_required?
    crypted_password.blank? || !password.blank?
  end
end
