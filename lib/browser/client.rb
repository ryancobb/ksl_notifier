module Browser
  class Client
    include Capybara::DSL

    def initialize
      Capybara.default_driver = :poltergeist
    end
  end
end