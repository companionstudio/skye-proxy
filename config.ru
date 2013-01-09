require 'sinatra/base'
require 'mechanize'

class SkyeProxy < Sinatra::Base
  class Github
    def self.token(code)
      params = {
        :client_id      => ENV['CLIENT_ID'], 
        :client_secret  => ENV['CLIENT_SECRET'], 
        :code           => code
      }

      headers = {"Accept" => 'application/json'}

      response = client.post('https://github.com/login/oauth/access_token', params, headers)

      response.body
    end

    private

    def self.client
      @@client ||= Mechanize.new
    end
  end


  post '/token' do
    content_type 'application/json'
    Github.token(params[:code])
  end
end

run Rack::URLMap.new("/" => SkyeProxy.new)

