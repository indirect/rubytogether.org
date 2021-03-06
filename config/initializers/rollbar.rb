Rollbar.configure do |config|
  config.access_token = ENV.fetch("ROLLBAR_ACCESS_TOKEN")

  # By default, Rollbar will try to call the `current_user` controller method
  # to fetch the logged-in user object, and then call that object's `id`,
  # `username`, and `email` methods to fetch those properties. To customize:
  # config.person_method = "my_current_user"
  # config.person_id_method = "my_id"
  # config.person_username_method = "my_username"
  # config.person_email_method = "my_email"

  # If you want to attach custom data to all exception and message reports,
  # provide a lambda like the following. It should return a hash.
  # config.custom_data_method = lambda { {:some_key => "some_value" } }

  # Add exception class names to the exception_level_filters hash to
  # change the level that exception is reported at. Note that if an exception
  # has already been reported and logged the level will need to be changed
  # via the rollbar interface.
  # Valid levels: 'critical', 'error', 'warning', 'info', 'debug', 'ignore'
  # 'ignore' will cause the exception to not be reported at all.
  config.exception_level_filters.merge!("ActionController::RoutingError" => "ignore")
  #
  # You can also specify a callable, which will be called with the exception instance.
  # config.exception_level_filters.merge!('MyCriticalException' => lambda { |e| 'critical' })

  # Enable asynchronous reporting
  config.use_async = true
end if ENV.has_key?("ROLLBAR_ACCESS_TOKEN")

module Rollbar
  class << self

    alias old_error error

    def error(*args)
      e = args.first
      ::Rails.logger.error("#{e.class}: #{e.message}\n#{e.backtrace.join(" \n")}")
      old_error(*args)
    end

  end
end if Rails.env.development?
