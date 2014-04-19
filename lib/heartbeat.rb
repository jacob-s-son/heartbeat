require 'pry'

module Heartbeat
  version = '0.0.1'
end

# custom exceptions
require File.expand_path('heartbeat/exceptions/obligatory_fields_missing', File.dirname(__FILE__))

require File.expand_path('heartbeat/monitor', File.dirname(__FILE__))