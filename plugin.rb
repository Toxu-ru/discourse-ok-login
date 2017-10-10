# name: discourse-ok-login
# about: Authenticate with discourse with ok.com, see more at: 
# version: 0.2.4
# author: Sam Saffron, stereobooster, Evg
# url: https://github.com/stereobooster/discourse-ok-login

enabled_site_setting :ok_client_id
enabled_site_setting :ok_client_secret

gem 'omniauth-odnoklassniki', '1.3.6'

# load the engine
load File.expand_path('../lib/ok.rb', __FILE__)

auth_provider :frame_width => 920,
              :frame_height => 800,
              :authenticator => Ok::Authenticator.new

register_asset "stylesheets/ok_styles.scss"
