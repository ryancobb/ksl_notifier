require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KslNotifier
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << Rails.root.join('lib')
    config.enable_dependency_loading = true
    
    config.ksl = config_for(:ksl)
  end
end

Raven.configure do |config|
  config.dsn = 'https://a06befeac1ed4811b075f1bcd524d944:11be766995914dd98d752b989fedc11f@sentry.io/213191'
end