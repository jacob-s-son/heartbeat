require 'spec_helper.rb'

describe Heartbeat::Monitor do
  let(:partial_options) {
    {
      url: "http://google.com",
      name: "Google"
    }
  }

  let(:full_options){
    {
      url: "http://google.com",
      name: "Google",
      description: "Searches things on the internet",
      frequency: 60,
      timeout: 10,
      success_codes: [ 200..299, 300..399 ]
    }
  }

  describe "#initialize" do
    context "no options specified" do
      subject { klass.new( {} ) }

      it "should raise exception that url is missing" do
        expect { klass.new({}) }.to(
          raise_error(Heartbeat::Exceptions::ObligatoryFieldsMissing, 'You need to specify url!')
        )
      end

      it "should raise exception that name is missing" do
        expect { klass.new({url: 'http://google.com'}) }.to(
          raise_error(Heartbeat::Exceptions::ObligatoryFieldsMissing, 'You need to specify name!')
        )
      end
    end

    context "basic options specified" do
      subject { klass.new( partial_options ) }

      it "should initialize url, name, specified and with defaults for other settings" do
        expect(subject.url).to            eq partial_options[:url]
        expect(subject.name).to           eq partial_options[:name]
        expect(subject.description).to    eq nil
        expect(subject.frequency).to      eq 30
        expect(subject.timeout).to        eq 15
        expect(subject.success_codes).to  eq [ 200..299 ]
      end
    end

    context "full options specified" do
      subject { klass.new( full_options ) }

      it "should initialize with params specified in options" do
        expect(subject.url).to            eq partial_options[:url]
        expect(subject.name).to           eq partial_options[:name]
        expect(subject.description).to    eq "Searches things on the internet"
        expect(subject.frequency).to      eq 60
        expect(subject.timeout).to        eq 10
        expect(subject.success_codes).to  eq [ 200..299, 300..399 ]
      end
    end
  end
end