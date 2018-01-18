module Browser
  SESSION_POOL = ::ConnectionPool.new(:size => 3, :timeout => 60) { ::Capybara::Session.new(:selenium_chrome_headless) }
end