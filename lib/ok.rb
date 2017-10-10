require File.expand_path('../ok/engine', __FILE__)
require File.expand_path('../ok/authenticator', __FILE__)

module Ok
  module OkExtender
    def self.included(klass)
      klass.has_one :odnoklassniki_user_info, dependent: :destroy, class_name: "::OdnoklassnikieUserInfo"
    end
  end
end
