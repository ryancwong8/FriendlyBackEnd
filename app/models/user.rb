class User < ActiveRecord::Base
  validates :auth_token, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  #before creating a user must generate authentication token
  before_create :generate_authentication_token!

  #flow for authenticating users through an API
  #1.Client requests for sessions resources with email and password
  #2.Server returns user resource along with authentication token
  #3.Pages that require authentication, client must send authentication token
  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

end
