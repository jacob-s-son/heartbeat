module Heartbeat
  class LiveChecker
    attr_reader :error_handler

    def initialize(url, success_codes, error_handler = ErrorHandler.new)
      @url           = url
      @success_codes = success_codes
      @error_handler = error_handler
    end

    def check
      res = HTTPClient.get(@url)
      if request_successful?(res.status)
        :success
      else
        error_handler.register_error(
          {
            type: :status_error,
            details: { status: res.status, body: res.body  }
          }
        )
        :error
      end
    end

    def reset
      error_handler.reset
    end

  private
    def request_successful?(status)
      @success_codes.any? do |range|
        case
          when range.is_a?(Array) || range.is_a?(Range)
            range.include?( status )
          when range.is_a?(Fixnum) then range == status
          else false
        end
      end
    end
  end
end