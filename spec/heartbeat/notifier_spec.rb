require 'spec_helper'

describe Heartbeat::Notifier do
  let(:strategy) { Heartbeat::NotificationStrategies::EmailStrategy.new }
  let(:error)    {
    {
      type: :status_error,
      details: { status: 500, body: "Something went wrong" }
    }
  }

  let(:timeout_error) {
    {
      type: :timeout_error
    }
  }

  let(:options) {
    {
      name: "Google",
      url: "http://google.com",
      notification_strategy: :email
    }
  }

  let(:body) {
    <<-EOS
      Returned status code: 500
      Response body:
      Something went wrong
    EOS
  }

  describe ".configure" do
    it "should create private instance with settings specified" do
      expect( klass ).to receive(:new).with(options)
      klass.configure( options )
    end
  end


  describe ".notify" do
    context "not configured" do
      it "should raise error" do
        klass.reset
        expect { klass.notify(:error, error) }.to raise_error('Notifier not configured!')
      end
    end

    context "configured" do
      before {
        Heartbeat::NotificationStrategies::EmailStrategy.stub(new: strategy)
        klass.configure(options)
      }

      context "status error notification" do
        it "should delegate sending to specified strategy" do
          expect(strategy).to receive(:send_message).with(
            subject: "#{options[:name]} returned error at #{options[:url]}",
            body: body
          )

          klass.notify( :error, error )
        end
      end

      context "timeout error notification" do
        it "should delegate sending to specified strategy" do
          expect(strategy).to receive(:send_message).with(
            subject: "#{options[:name]} returned timeout error at #{options[:url]}",
            body: nil
          )

          klass.notify( :error, timeout_error )
        end
      end

      context "back to normal notification" do
        it "should delegate sending to specified strategy" do
          expect(strategy).to receive(:send_message).with(
            subject: "#{options[:name]} at #{options[:url]} is online",
            body: nil
          )

          klass.notify( :back_to_normal )
        end
      end
    end
  end
end