Sorcery.configure do |config|
  config.user_class = 'User'
  config.session_class = 'UserSession'
  config.username_attr_names = [:username]

  config.password_hashing_algorithm = :argon2
  config.session_store = :jwt_session

  config.load_plugin(:brute_force_protection)
  config.load_plugin(:jwt, {
    controller: {
      jwt_secret: ENV.fetch('SECRET_KEY_BASE', nil)
    }
  })
end
