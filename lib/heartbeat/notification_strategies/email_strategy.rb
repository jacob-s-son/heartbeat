module Heartbeat
  module NotificationStrategies
    class EmailStrategy
      def initialize(settings={})
        @smtp_settings  = settings[:smtp_settings]
        @to             = settings.delete(:to)
        @from           = settings.delete(:from) || 'notification@heartbeat.com'
      end

      def send_message(message)
        Pony.mail({
          to:           @to,
          from:         @from,
          via:          :smtp,
          via_options:  @smtp_settings
        }.merge(message))
      end
    end
  end
end