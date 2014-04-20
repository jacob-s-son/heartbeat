require 'spec_helper'

describe Heartbeat::NotificationStrategies::EmailStrategy do
  let(:smtp_settings) {
    {
      address:        'smtp.yourserver.com',
      port:           '25',
      user_name:      'user',
      password:       'password',
      authentication: :plain, # :plain, :login, :cram_md5, no auth by default
      domain:         "localhost.localdomain" # the HELO domain provided by the client to the server
    }
  }

  let(:settings) {
    {
      to:           'you@example.com',
      from:         'notification@heartbeat.com',
      subject:      'Some subject',
      body:         'Some message body',
      via:          :smtp,
      via_options:  smtp_settings
    }
  }

  describe "#send_message" do
    subject { klass.new({ smtp_settings: smtp_settings, to: 'you@example.com' }) }
    it "call #mail on Pony" do
      expect(Pony).to receive(:mail).with(settings)
      subject.send_message( { subject: 'Some subject', body: 'Some message body' } )
    end
  end
end