module Browser
  class Client
    attr_accessor :html

    RESCUE_EXCEPTIONS = [
      ::Capybara::ElementNotFound,
      ::HTTPClient::BadResponseError,
      ::HTTPClient::ConnectTimeoutError,
      ::HTTPClient::KeepAliveDisconnected,
      ::Net::ReadTimeout,
      ::OpenSSL::SSL::SSLError,
    ].freeze

    def with_session
      ::Browser::DRIVER_POOL.with do |driver|
        begin
          driver.start_session!

          yield(driver.session)
          @html = driver.session.body
        rescue *RESCUE_EXCEPTIONS => e
          retry_count ||= 0 

          if retry_count < 1 
            ::Rails.cache.delete('current_proxy')
            retry_count += 1
            retry
          end

          raise e
        ensure
          driver.end_session!
        end
      end
    end
  end
end