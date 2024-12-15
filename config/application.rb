require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SimilarSongs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:en, :ja]
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.generators.system_tests = nil
    config.generators do |g|
      g.skip_routes true
      g.assets false
      g.helper false
      g.test_framework nil
    end
  end
end
