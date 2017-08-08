module Browser
  class Client
    include Capybara::DSL

    def initialize
      Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new(app, :browser => :chrome,
          :options => ::Selenium::WebDriver::Chrome::Options.new(:args => ['headless']))
      end
    end
  end
end