MDme::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  #config.action_mailer.delivery_method = :letter_opener
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.smtp_settings = {
  #    address:              ENV['EMAIL_SERVER'],#smtpout.secureserver.net',
  #    port:                 ENV['EMAIL_PORT'],#80,
  #    domain:               ENV['EMAIL_DOMAIN'],#mdme.us,
  #    user_name:            ENV['EMAIL_USERNAME'],
  #    password:             ENV['EMAIL_PASSWORD'],
  #    authentication:       ENV['EMAIL_AUTHENTICATION'],
  #    enable_starttls_auto: true  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  #for paperclip to use imagemagick
  Paperclip.options[:command_path] = '/usr/bin/'

  #raise errors in after_commit/after_rollback
  config.active_record.raise_in_transactional_callbacks = true

  #for bullet to work - differnet types of notifications
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end
  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.alert = true
  #   Bullet.bullet_logger = true
  #   Bullet.console = true
  #   #Bullet.growl = true
  #   #Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
  #   #                :password => 'bullets_password_for_jabber',
  #   #               :receiver => 'your_account@jabber.org',
  #   #                :show_online_status => true }
  #   Bullet.rails_logger = true
  #   #Bullet.airbrake = true
  #   Bullet.add_footer = true
  # end
end
