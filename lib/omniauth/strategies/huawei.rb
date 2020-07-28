require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class Huawei < OmniAuth::Strategies::OAuth2
      option :client_options, {
          :site => 'https://oauth-login.cloud.huawei.com',
          :authorize_url => 'https://oauth-login.cloud.huawei.com/oauth2/v3/authorize?access_type=offline&scope=openid+profile',
          :token_url => 'https://oauth-login.cloud.huawei.com/oauth2/v3/token'
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
              # to support omniauth-oauth2's auto csrf protection
              session['omniauth.state'] = params[:state] if v == 'state'
            end
          end
        end
      end

      uid { raw_info['sub'].to_s }

      info do
        {
          'name' => raw_info['display_name'],
          'image' => raw_info['picture'],
          'email' => raw_info['email']
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        id_token = access_token.params['id_token']
        # 验证失败会500，成功返回json格式的数据
        @raw_info ||= JWT.decode(id_token, nil, false,
                                 verify_iss: true,
                                 iss: 'https://accounts.huawei.com',
                                 verify_aud: true,
                                 aud: options.client_id,
                                 verify_expiration: true).first
      rescue
        # 本地验证失败后，向华为的服务器发起验证请求，返回json格式的数据
        @raw_info ||= access_token.get("/oauth2/v3/tokeninfo?id_token=#{id_token}").parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'huawei', 'Huawei'
