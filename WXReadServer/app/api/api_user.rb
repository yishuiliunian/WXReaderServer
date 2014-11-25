module ApiUser
  module ErrorFormatter
    def self.call message, bactrace, options, evn
      {:response_type => 'error', :response => message}.to_json
    end
  end

  class API < Grape::API
    format :json
    prefix "apiuser"

    rescue_from :all, :backtrace => true
    error_formatter :json, ApiUser::ErrorFormatter

    resource :user do
      desc "sign in"
      params do
        requires :email, :type=>String, :desc => "邮箱"
        requires :password, :type=>String, :desc => "密码"
      end

      get do

        email = params[:email]
        password = params[:password]

        user = User.find_by_email(email)
        if user == nil
          error!("email is wrong!", -8991)
        end

        if password != user.encrypted_password
          error!("password is wrong!", -8981)
        end

        token = Devise.friendly_token
        $redis.set(token, token)
        $redis.expire(token, GlobalSettings.token_experie_time)
        {"token" => token}.to_json
      end
    end
  end
end
