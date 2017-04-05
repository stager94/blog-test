class User < ApplicationRecord

  include Users::Rolify

  has_secure_password

  has_many :posts
  has_many :comments

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: true }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def self.authenticate(email, password)
    user = User.find_by email: email
    user.authenticate password[0] if user
  end

end
