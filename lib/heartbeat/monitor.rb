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
      options = DEFAULTS.merge(options)

      if options[:url].nil?
        raise Exceptions::ObligatoryFieldsMissing, 'You need to specify url!'
      elsif options[:name].nil?
        raise Exceptions::ObligatoryFieldsMissing, 'You need to specify name!'
      end

      ATTRIBUTES.each do |attrib|
        send( "#{attrib}=", options[attrib] )
      end
    end
  end
end