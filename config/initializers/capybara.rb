Capybara.default_max_wait_time = 10

Capybara.register_driver :custom_chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 10 # instead of the default 60

  Capybara::Selenium::Driver.new(app, :browser => :chrome, :http_client => client,
    :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.chrome({
      :chromeOptions => {
        'extensions' => [
          Base64.strict_encode64(File.open('/Users/ryancobb/Downloads/adblock.crx', 'rb').read)
        ]
      }
    })
  )
end