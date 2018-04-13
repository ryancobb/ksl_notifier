module Browser
  class Driver
    attr_reader :session

    def start_session!
      @session = ::Capybara::Session.new(:selenium_chrome_headless)
      set_proxy
    end

    def end_session!
      @session.driver.quit
    end

    private

    def fetch_proxy
      proxy = proxy_manager.get!

      "http://#{proxy.addr}:#{proxy.port}"
    end

    def proxy
      Rails.cache.fetch('current_proxy', :expires_in => 1.hour) do
        fetch_proxy
      end
    end

    def proxy_manager
      @proxy_manager ||= ::ProxyFetcher::Manager.new
    end
    
    def set_proxy
      # This is needed for testing. When running chrome in not headless mode the driver will not have options attached.
      if session.driver.options[:options].nil?
        session.driver.options[:options] = ::Selenium::WebDriver::Chrome::Options.new
      end

      session.driver.options[:options].args << "proxy-server=#{proxy}"
    end
  end
end