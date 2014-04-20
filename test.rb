require 'sinatra'

get '/success' do
  "Hello World!"
end

get '/error' do
  2 / 0
end

get 'timeout' do
  sleep 300
end