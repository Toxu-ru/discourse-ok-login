module Ok
  class Authenticator < ::Auth::Authenticator

    def name
      'odnoklassniki'
    end

    def after_authenticate(auth_token)

      result = ::Auth::Result.new

      session_info = parse_auth_token(auth_token)
      odnoklassniki_hash = session_info[:odnoklassniki]

      result.email = email = session_info[:email]
      result.email_valid = !email.blank?
      result.name = odnoklassniki_hash[:name]

      result.extra_data = odnoklassniki_hash

      user_info = ::OdnoklassnikiUserInfo.find_by(odnoklassniki_user_id: odnoklassniki_hash[:odnoklassniki_user_id])
      result.user = user_info.try(:user)

      if !result.user && !email.blank? && result.user = ::User.find_by_email(email)
       ::OdnoklassnikiUserInfo.create({user_id: result.user.id}.merge(odnoklassniki_hash))
      end

      if email.blank?
        ::UserHistory.create(
          action: ::UserHistory.actions[:odnoklassniki_no_email],
          details: "name: #{odnoklassniki_hash[:name]}, odnoklassniki_user_id: #{odnoklassniki_hash[:odnoklassniki_user_id]}"
        )
      end

      result
    end

    def after_create_account(user, auth)
     data = auth[:extra_data]
     ::OdnoklassnikiUserInfo.create({user_id: user.id}.merge(data))
    end

    def register_middleware(omniauth)
      omniauth.provider :odnoklassniki,
             :setup => lambda { |env|
                strategy = env["omniauth.strategy"]
                strategy.options[:client_id] = ::SiteSetting.ok_client_id
                strategy.options[:client_secret] = ::SiteSetting.ok_client_secret
             },
             :scope => "email"
    end

    protected

      def parse_auth_token(auth_token)

        raw_info = auth_token["extra"]["raw_info"]
        email = auth_token["info"][:email] || auth_token["info"]["email"]

        # https://github.com/mamantoha/omniauth-vkontakte#authentication-hash

        {
          odnoklassniki: {
            odnoklassniki_user_id: auth_token["uid"],
            link: raw_info["link"],
            username: raw_info["nickname"],
            first_name: raw_info["first_name"],
            last_name: raw_info["last_name"],
            email: email,
            gender: raw_info["sex"],
            name: raw_info["screen_name"]
          },
          email: email,
          email_valid: true
        }

      end

  end
end
