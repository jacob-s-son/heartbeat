require 'spec_helper.rb'

describe Heartbeat::Logger do

  let(:file) { StringIO.new }

  describe ".configure" do
    it "should set output to the stream specified in options" do
      klass.configure( { stream: file } )
      expect(klass.stream).to eq file
    end
  end

  describe ".log" do
    before {
      time = Time.now
      Time.stub(now: time)
    }

    context "when output stream is not configured" do
      it "should output to stdout" do
        klass.configure({ stream: nil })
        expect( $stdout ).to receive(:puts).with("[#{Time.now}] Test")
        klass.log( "Test" )
      end
    end

    context "when output stream is configured" do
      it "should output to to it" do
        klass.configure({ stream: file })
        expect( file ).to receive(:puts).with("[#{Time.now}] Test")
        klass.log( "Test" )
      end
    end
  end
end