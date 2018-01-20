module Browser
  class Client
    attr_accessor :html

    def with_session
      ::Browser::DRIVER_POOL.with do |driver|
        driver.start_session!

        yield(driver.session)
        @html = driver.session.body

        driver.end_session!
      end
    end
  end
end