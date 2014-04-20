module Heartbeat
  class Notifier
    class << self
      def configure(options)
        @notifier = new(options)
      end

      def notify(notification_type, data={})
        raise 'Notifier not configured!' unless @notifier
        @notifier.notify(notification_type, data)
      end

      def reset
        @notifier = nil
      end
    end

    def initialize(options)
      @options = { notification_strategy: :email }.merge(options)
    end

    def notify(notification_type, data={})
      strategy.send_message message(notification_type, data)
    end

  private
    def strategy
      @strategy ||= begin
        name = @options[:notification_strategy].to_s

        full_name =
          "#{name[0].upcase}#{name[1..-1]}Strategy"

        Kernel.const_get(
          "Heartbeat::NotificationStrategies::#{full_name}"
        ).new(@options[:strategy_settings])
      end
    end

    def message(type, data)
      prefix = type == :error ? data[:type] : type

      {
        subject: send("#{prefix}_subject"),
        body:    send("#{prefix}_body", data)
      }
    end

    def back_to_normal_subject
      "#{@options[:name]} at #{@options[:url]} is online"
    end

    def back_to_normal_body(data)
      nil
    end

    def status_error_subject
      "#{@options[:name]} returned error at #{@options[:url]}"
    end

    def status_error_body(data)
      <<-EOS
      Returned status code: #{data[:details][:status]}
      Response body:
      #{data[:details][:body]}
      EOS
    end

    def timeout_error_subject
      "#{@options[:name]} returned timeout error at #{@options[:url]}"
    end

    def timeout_error_body(data)
      nil
    end
  end
end