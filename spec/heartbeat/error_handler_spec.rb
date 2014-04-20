require 'spec_helper.rb'

describe Heartbeat::ErrorHandler do
  before(:all) {
    configure_notifier
  }

  subject { klass.new }
  let(:error) { { type: "Some error", details: {} } }

  describe ".new" do
    context "alert times not specified" do
      it "should create an instance of ErrorHandler with default alert times" do
        expect( subject.alert_times ).to eq( [ 3, 10, 50, 100, 500 ] )
      end
    end

    context "alert times are specified" do
      subject { klass.new([5, 10]) }
      it "should create an instance of TiemoutHandler with specified alert times" do
        expect( subject.alert_times ).to eq( [ 5, 10 ] )
      end
    end
  end

  describe "#register_error" do
    before      { subject.register_error(error) }

    it "should increase counter" do
      expect( subject.counter ).to eq( 1 )
    end

    it "should put error into stack" do
      expect( subject.stack ).to eq( [ error ] )
    end

    context "counter value is included in alert times" do
      it "should call #notify on notifier" do
        expect( Heartbeat::Notifier ).to receive( :notify ).with( :error, error )
        2.times { subject.register_error(error) }
      end
    end
  end

  describe "#reset" do
    before { subject.register_error(error) }
    it "should reset counter to zero" do
      expect( subject.counter ).to eq(1)
      subject.reset
      expect( subject.counter ).to eq(0)
    end

    it "should empty error stack" do
      expect( subject.stack ).not_to be_empty
      subject.reset
      expect( subject.stack ).to be_empty
    end

    it "should notify that application is up again" do
      expect( Heartbeat::Notifier ).to receive( :notify ).with( :back_to_normal )
      subject.reset
    end
  end
end