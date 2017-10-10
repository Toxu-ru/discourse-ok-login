module Ok
  class Engine < ::Rails::Engine
    isolate_namespace Ok

    # config.after_initialize do
    # end

    config.to_prepare do
      # inject our dependencies
      # runs once in production, before every request in development
      User.send(:include, Ok::OkExtender)
    end
  end
end
