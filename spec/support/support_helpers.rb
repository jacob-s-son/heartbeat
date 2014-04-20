require 'rspec/expectations'

module SupportHelpers
  # Gets the currently described class.
  # Conversely to +subject+, it returns the class
  # instead of an instance.
  def klass
    described_class
  end

  def configure_notifier
    Heartbeat::Notifier.configure({
      url:  "http://google.lv",
      name: "Google",
      notification_strategy: :fake,
      strategy_settings: {}
    })
  end
end