class User < ActiveRecord::Base
  has_and_belongs_to_many :companies

  validates_presence_of   :email
  validates_uniqueness_of :email

  attr_accessor         :password, :password_confirmation
  before_save           :hash_password
  before_validation     :hash_password
  validate              :validate_password_confirmation
  validates_presence_of :hashed_password

  def reset_password
    self.password = SecureRandom.hex(4)
    self.password_confirmation = self.password
  end

  def self.create_user(name, email, password)
    u = User.new
    u.name = name
    u.email = email
    u.password = password
    u.password_confirmation = password
    u.save!
  end

  def as_json(options = {})
    {
      id:     self.id,
      name:   self.name,
      email:  self.email
    }
  end

  private

  def validate_native_languages
    self.native_languages.each { |lang|
      unless Project::LANGUAGES.include? lang
        errors.add(:native_languages, "invalid language #{lang}")
      end
    }
  end

  def hash_password
    if self.password.present?
      self.hashed_password = BCrypt::Password.create(self.password)
    end
  end

  def validate_password_confirmation
    if self.password != self.password_confirmation
      errors.add(:password, "does not match")
    end
  end
end
