require 'sinatra'

get '/success' do
  "Hello World!"
end

get '/error' do
  2 / 0
end

get '/timeout' do
  if rand(10) % 10 == 0
    sleep 300
  else
    "Now works"
  end
end