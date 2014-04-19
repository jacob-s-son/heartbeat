require 'rspec/expectations'

module SupportHelpers
  # Gets the currently described class.
  # Conversely to +subject+, it returns the class
  # instead of an instance.
  def klass
    described_class
  end
end