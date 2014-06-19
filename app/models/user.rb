class User < ActiveRecord::Base
  # Use the before_save callback to ensure email uniqueness.
  # This occurs before a user is saved to the database.
  # (Could potentially occur more than once, e.g., if the user
  # changes his email address.)
  before_save { self.email = email.downcase }

  # Use the before_create callback to make sure a remember_token
  # is created for the user. (Done when user is created.)
  before_create :create_remember_token

  # Validate the username
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validate the email
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false}

  # Note: wherever we have a validation of the form
  # format: { attribute: value }
  # the `format` is assumed by Rails to be true.

  # Make sure typed passwords are only virtual and that persisted
  # passwords (those saved to the db) are secure (digested)
  has_secure_password

  # Validate the password
  validates :password, length: { minimum: 8 }


  # If methods are prefixed with User., they are class methods
  # (they do not pertain to a particular user instance / object,
  # but can be used anywhere by any user object, or any external
  # object?)
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
