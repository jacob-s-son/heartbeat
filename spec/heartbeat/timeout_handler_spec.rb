require 'spec_helper.rb'

describe Heartbeat::TimeoutHandler do
  subject { klass.new }

  describe ".new" do
    context "alert times not specified" do
      it "should create an instance of TiemoutHandler with default alert times" do
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

  describe "#trigger" do
    context "alerting number of timeouts not reached" do
      it "should only increase counter" do
        expect( subject.counter ).to eq 0
        subject.trigger
        expect( subject.counter ).to eq 1
      end
    end

    context "alerting number of timeouts not reached" do
      it "should only increase counter" do
        expect( subject.counter ).to eq 0
        expect( Heartbeat::Logger ).to receive( :log ).with( "Number of timeouts exceeded. Sending notification" )

        3.times { subject.trigger }
        expect( subject.counter ).to eq 3
      end
    end
  end

  describe "#reset" do
    it "should reset counter to zero" do
      expect( subject.counter ).to eq(0)
      subject.trigger
      expect( subject.counter ).to eq(1)
      subject.reset
      expect( subject.counter ).to eq(0)
    end
  end
end