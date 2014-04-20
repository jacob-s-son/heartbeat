require 'pry'
require 'timeout'
require 'pony'

module Heartbeat
  version = '0.0.1'
end

# custom exceptions
require File.expand_path('heartbeat/exceptions/obligatory_fields_missing', File.dirname(__FILE__))

require File.expand_path('heartbeat/notification_strategies/email_strategy', File.dirname(__FILE__))
require File.expand_path('heartbeat/notification_strategies/fake_strategy',  File.dirname(__FILE__))

require File.expand_path('heartbeat/logger',          File.dirname(__FILE__))
require File.expand_path('heartbeat/notifier',   File.dirname(__FILE__))
require File.expand_path('heartbeat/error_handler',   File.dirname(__FILE__))
require File.expand_path('heartbeat/live_checker',    File.dirname(__FILE__))
require File.expand_path('heartbeat/timeout_handler', File.dirname(__FILE__))
require File.expand_path('heartbeat/monitor',         File.dirname(__FILE__))
require File.expand_path('heartbeat/looper',          File.dirname(__FILE__))
