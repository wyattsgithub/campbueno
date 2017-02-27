class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :omniauthable

  validates :email, presence: true, email: true, on: :update

  def self.find_for_oauth(auth, user=nil)
    identity = Identity.find_for_oauth(auth)
    user ||= identity.user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      name = auth.extra.raw_info.name.split(' ', 2)

      if user.nil?
        user = User.new(
          first_name: name.first,
          last_name: name.last,
          email: email || '',
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end
end
