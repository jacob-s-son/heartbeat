module Heartbeat
  class Logger
    class << self
      attr_reader :stream

      def configure(options)
        @stream = options[:stream]
        @logger = nil
      end

      def log(message)
        @logger ||= new(stream)
        @logger.log( message )
      end
    end

    def initialize(stream = $stdout)
      @stream = stream
    end

    def log(message)
      stream.puts( message )
    end
  private
    def stream
      @stream || $stdout
    end
  end
end