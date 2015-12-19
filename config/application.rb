require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Insurance
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    require Rails.root.join('app/models/concerns/model_treasure_chest.rb')
    require Rails.root.join('lib/tools.rb')
    require Rails.root.join('lib/car_user_info_parse/tao_che.rb')
    require Rails.root.join('lib/car_user_info_parse/che168.rb')
    require Rails.root.join('lib/car_user_info_parse/upload_tian_tian.rb')

    config.action_mailer.raise_delivery_errors = true
    config.action_controller.include_all_helpers = false

    config.prepend_helpers_path = true

    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'

    #
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
    #     :address              => "smtp.qq.com",
    #     :port                 => 587,
    #     :user_name            => '379576382@qq.com',
    #     :password             => 'llx667^^&',
    #     :authentication       => 'plain',
    #     :enable_starttls_auto => true
    # }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address              => "smtp.exmail.qq.com",
        :port                 => 587,
        :user_name            => 'noreply@ikidstv.com',
        :password             => 'ikidstv2014',
        :authentication       => 'plain',
        :enable_starttls_auto => true
    }
  end
end
