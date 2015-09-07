class User < ActiveRecord::Base
  has_many :bookings

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.profile_url = auth.info.image
      user.first_name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.save!
    end
  end

  def self.auth_name
    if self.info.name == '' || nil?
      return self.info.login
    else
      return self.info.name
    end
  end
end
