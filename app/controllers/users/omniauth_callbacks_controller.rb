class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  [:google_oauth2, :facebook].each do |provider|
    define_method(provider) do
      auth = env["omniauth.auth"]
      identity = Identity.find_or_create_by(uid: auth.uid, provider: auth.provider)

      if identity.user
        sign_in_and_redirect identity.user, event: :authentication
      else
        name = auth.extra.raw_info.name.split(' ', 2)

        redirect_to new_user_registration_url(
          user: {
            identity_id: identity.id,
            email: auth.info.email,
            first_name: name.first,
            last_name: name.last
          }
        )
      end
    end
  end
end