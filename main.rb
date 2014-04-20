require './lib/heartbeat'

options = {
  url: "http://google.com",
  name: "Google",
  notification_strategy: :email,
  notification_strategy_options: {
    to:           'jekabsons.edgars@gmail.com',
    from:         'notification@heartbeat.com',
    via:          :smtp,
    smtp_settings:  {
      address:        'smtp.mandrillapp.com',
      port:           '587',
      user_name:      'jekabsons.edgars@gmail.com',
      password:       ENV['MANDRIL_API_KEY'],
      authentication: :plain # :plain, :login, :cram_md5, no auth by default
    }
  },
  description: "Searches things on the internet",
  frequency: 5,
  timeout: 3,
  success_codes: [ 200..299 ]
}

monitor = Heartbeat::Monitor.new(options)
monitor.run