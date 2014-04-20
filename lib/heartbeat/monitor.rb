module Heartbeat
  class Monitor
    ATTRIBUTES = [:name, :url, :description, :frequency, :timeout, :success_codes]

    DEFAULTS = {
      frequency: 30,
      timeout: 15,
      success_codes: [ 200..299 ]
    }

    attr_accessor *ATTRIBUTES

    def initialize(options)
      @options = DEFAULTS.merge(options)

      if @options[:url].nil?
        raise Exceptions::ObligatoryFieldsMissing, 'You need to specify url!'
      elsif @options[:name].nil?
        raise Exceptions::ObligatoryFieldsMissing, 'You need to specify name!'
      end

      ATTRIBUTES.each do |attrib|
        send( "#{attrib}=", @options.delete(attrib) )
      end

      Notifier.configure({
        notification_strategy: options[:notification_strategy],
        name:                  name,
        url:                   url,
        strategy_options:      options[:notification_strategy_options]
      })
    end

    def run(times_to_run = nil)
      Looper.new(frequency, timeout, times_to_run, timeout_handler) do
        live_checker.check
      end
    end
  private
    def error_handler
      @error_handler ||= ErrorHandler.new(@options[:alert_times])
    end

    def timeout_handler
      @timeout_handler  ||= TimeoutHandler.new(error_handler)
    end

    def live_checker
      @live_checker ||= LiveChecker.new( url, success_codes, error_handler )
    end
  end
end