require 'webmock/rspec'
require 'heartbeat'

# Load support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  # Include helper methods to shorten test code
  config.include SupportHelpers
end
