class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:facebook,:linkedin,:twitter]

 def self.from_omniauth(auth)
 
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name  
       user.oauth_token = auth.credentials.token
       user.secret = auth.credentials.secret
       
        #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
       
       
       # assuming the user model has a name
      # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
 end
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def facebook 
      @facebook ||= Koala::Facebook::API.new(oauth_token)
      block_given? ? yield(@facebook) : @facebook
      rescue Koala::Facebook::APIError => e
      logger.info e.to_s
       nil
  end

   def linkedin
     client = LinkedIn::Client.new('789drox3kvi9yb', 'q0jWcOhXHAkv3tVJ')
     client.authorize_from_access(oauth_token,  secret)
     client
   end

  def twitter  
     client = TwitterAds::Client.new(
      '7nXj6kDFMi8T30PXJoD2qTL2T',
      'Rf3QDH6ucMFzsI3Ia2fX1E4e2TQEHWnuoSz2IVrKftSsZFjBDs',
      oauth_token,
      secret)
  end

end









 



