module Heartbeat
  module NotificationStrategies
    class FakeStrategy
      def initialize(settings={})
        @settings = settings
      end

      def send_message(message)
      end
    end
  end
end