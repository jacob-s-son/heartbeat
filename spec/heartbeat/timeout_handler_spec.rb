require 'spec_helper.rb'

describe Heartbeat::TimeoutHandler do
  before(:all)        { configure_notifier }
  let(:error_handler) { Heartbeat::ErrorHandler.new }
  subject             { klass.new(error_handler) }

  describe "#trigger" do
    it "should register error at error handler" do
      expect( error_handler ).to(
        receive(:register_error).with(
          {
            type: :timeout_error,
            details: {}
          }
        )
      )

      subject.trigger
    end
  end

  describe "#reset" do
    it "should reset error handler" do
      expect( error_handler ).to receive(:reset)
      subject.reset
    end
  end
end