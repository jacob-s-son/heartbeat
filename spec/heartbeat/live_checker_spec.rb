require 'spec_helper.rb'

describe Heartbeat::LiveChecker do
  before(:all)        { configure_notifier }
  let(:error_handler) { Heartbeat::ErrorHandler.new }
  let(:success_codes) { [ 200..299 ]                }
  let(:url)           { "http://google.lv"          }

  subject { klass.new(url, success_codes, error_handler) }

  describe "#check" do
    context "returned HTTP code is in range of successfull codes" do
      before {
        stub_request(:get, url).to_return(status: 200, body: "stubbed response", headers: {})
      }

      it "should not register error at error handler" do
        expect( error_handler ).not_to receive(:register_error)
        subject.check
        expect(WebMock).to have_requested(:get, url)
      end
    end

    context "returned HTTP code is not in range of successfull codes" do
      before {
        stub_request(:get, url).to_return(status: 500, body: "Something went wrong", headers: {})
      }

      it "should register error at error handler" do
        expect( error_handler ).to(
          receive(:register_error).with(
            {
              type: :status_error,
              details: { status: 500, body: "Something went wrong"  }
            }
          )
        )

        subject.check
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end

  describe "#reset" do
    it "should call reset on error handler" do
      expect( error_handler ).to receive(:reset)
      subject.reset
    end
  end
end