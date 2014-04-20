module Heartbeat
  class Looper
    attr_accessor :frequency, :timeout_in_seconds

    def initialize(frequency, timeout_in_seconds, times_to_run = nil, timeout_handler = TimeoutHandler.new, &block)
      self.frequency          = frequency
      self.timeout_in_seconds = timeout_in_seconds

      unless block_given?
        raise Exceptions::ObligatoryFieldsMissing, 'You need to specify code block to run!'
      end

      last = Time.now
      while ( times_to_run.nil? ? true : times_to_run > 0 )
        begin
          Timeout::timeout(timeout_in_seconds) do
            yield
          end
          timeout_handler.reset
        rescue Timeout::Error
          timeout_handler.trigger
        end

        now = Time.now
        _next = [last + frequency, now].max
        sleep( _next - now)
        last = _next

        times_to_run -= 1 if times_to_run
      end
    end
  end
end