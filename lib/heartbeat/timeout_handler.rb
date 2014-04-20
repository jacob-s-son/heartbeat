module Heartbeat
  class TimeoutHandler
    attr_reader :error_handler

    def initialize(error_handler = ErrorHandler.new)
      @error_handler = error_handler
    end

    def trigger
      error_handler.register_error({ type: :timeout_error, details: {} })
    end

    def reset
      error_handler.reset
    end

    def counter
      error_handler.counter
    end
  end
end