module Browser
  class Client
    include ::Capybara::DSL
    attr_reader :session

    def initialize
      @session = ::Capybara::Session.new(:selenium_chrome_headless)
    end
  end
end