module Browser
  class Client
    attr_accessor :html

    def with_session
      ::Browser::SESSION_POOL.with do |session|
        yield(session)
        @html = session.body
        session.reset!
      end
    end
  end
end