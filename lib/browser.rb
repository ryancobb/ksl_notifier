require 'browser/client'

module Browser
  DRIVER_POOL = ::ConnectionPool.new(:size => 3, :timeout => 180) { ::Browser::Driver.new }
end