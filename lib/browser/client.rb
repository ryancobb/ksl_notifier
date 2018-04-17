module Browser
  class Client
    attr_accessor :html

    def with_session
      ::Browser::DRIVER_POOL.with do |driver|
        begin
          driver.start_session!
          yield(driver.session)
          @html = driver.session.body
        ensure
          driver.end_session!
        end
      end
    end
  end
end