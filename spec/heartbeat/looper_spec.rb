require 'spec_helper.rb'

describe Heartbeat::Looper do
  let(:frequency) { 30 }
  let(:timeout)   { 15 }
  let(:times)     { 2 }

  describe ".new" do
    let(:timeout_handler) { Heartbeat::TimeoutHandler.new }

    context "loop block is missing" do
      it "should raise exception that loop block is missing" do
        expect { klass.new( frequency, timeout ) }.to(
          raise_error(Heartbeat::Exceptions::ObligatoryFieldsMissing, 'You need to specify code block to run!')
        )
      end
    end

    context "number of iterations sepcified" do
      subject { klass.new( 1, timeout, times) { Heartbeat::Logger.log("lala") } }
      it "should end loop" do
        expect(Heartbeat::Logger).to receive(:log).with("lala").exactly(times).times
        subject
      end
    end

    context "block takes too long to finish" do
      subject { klass.new( 1, 0.5, times, timeout_handler) { sleep 0.6 } }

      it "should trigger timeout handler" do
        expect(timeout_handler).to receive( :trigger ).exactly(2).times
        subject
      end
    end

    context "when after timeout next call succeeds" do
      subject {
        time = Time.now.to_i

        # we preserve time inside block to get different sleep values
        klass.new( 2, 0.5, times, timeout_handler ) do
          if time + 2 > Time.now.to_i # if it's first run, wetriger timeout
            sleep(0.6)
          else # otherwise everything is back to normal and we trigger counter
            sleep(0.1)
          end
        end
      }

      it "should call reset on timeout handler" do
        expect(timeout_handler).to receive( :trigger ).exactly(1).times
        expect(timeout_handler).to receive( :reset   ).exactly(1).times
        subject
      end
    end
  end
end