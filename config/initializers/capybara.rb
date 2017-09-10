Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome,
    :options => ::Selenium::WebDriver::Chrome::Options.new(:args => ['headless']))
end

Capybara.default_max_wait_time = 5