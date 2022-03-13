module Api
  module V1
    module Authenticable

      def authenticate_system_param_basic
        unless authenticate_with_http_basic { |username, password| ApiKey.find_by(name: username, password: password) }
          # render json: { error: 'Bad credentials'}, status: 401
          render json: { code: 401, message: "Bad credentials" }, status: 401
        end
      end

      def authenticate_system_param_token
        unless authenticate_with_http_token { |token, options| ApiKey.find_by(access_token: token) }
          # render json: { error: 'Bad token'}, status: 401
          render json: { code: 401, message: "Bad token" }, status: 401
        end
      end

      # simple method without extra controller for return token
      def token
        authenticate_with_http_basic do |username, password|
          system_for_api = ApiKey.find_by(name: username)
          if system_for_api && system_for_api.password == password
            render json: { token: system_for_api.access_token }, status: 200
          else
            # render json: { error: 'Incorrect credentials' }, status: 401
            render json: { code: 401, message: "Incorrect credentials" }, status: 401
          end
        end
      end

    end
  end
end