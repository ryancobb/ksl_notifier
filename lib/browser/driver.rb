module Browser
  class Driver
    attr_reader :session

    def start_session!
      @session = ::Capybara::Session.new(:selenium_chrome_headless)
    end

    def end_session!
      @session.driver.quit
    end
  end
end