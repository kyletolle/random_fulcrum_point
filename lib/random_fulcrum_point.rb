require 'dotenv'
Dotenv.load
require 'fastenv'

require 'sinatra/base'
require 'rack/cors'
require 'json'

class RandomFulcrumPoint
  class API < Sinatra::Base
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    # Idea from http://www.recursion.org/2011/7/21/modular-sinatra-foreman
    configure do
      set :app_file, __FILE__
      set :port, Fastenv.port
    end

    def always_create_record
      Fastenv.fulcrum_always_create_record
    rescue
      'false'
    end

    post '/' do
      def actually_create_record?
        return true if always_create_record == 'true'

        toggle_record_string = `curl -H "Content-Type: application/json" -H "X-ApiToken: #{Fastenv.fulcrum_api_key}"  https://web.fulcrumapp.com/api/v2/records/#{Fastenv.fulcrum_toggle_record_id}.json`
        toggle_record_hash = JSON.parse(toggle_record_string)
        toggle_value = toggle_record_hash['record']['form_values'][Fastenv.fulcrum_toggle_field_id]

        toggle_value == "yes"
      end

      unless actually_create_record?
        status 202
        return
      end

      random_point_string = `curl 'https://random-point-generator.herokuapp.com/random_point?sw_point=40.636883%2C-74.083214&ne_point=40.831476%2C-73.673630'`
      random_point_string.chop! # remove last `]` character
      random_point_string[0] = '' # remove first `[` character
      random_point = random_point_string.split ', ' # break into lat, long strings

      statuses = %W{red yellow green blue}
      random_status = statuses.sample
      payload_hash =
        {
          form_id:   Fastenv.fulcrum_form_id,
          latitude:  random_point[0],
          longitude: random_point[1],
          status:    random_status,
          form_values: { Fastenv.fulcrum_field_id => Time.now.to_i.to_s }
        }

      payload_json = JSON.generate(payload_hash)
      `curl -H "Content-Type: application/json" -H "X-ApiToken:#{Fastenv.fulcrum_api_key}" -d '#{payload_json}' https://web.fulcrumapp.com/api/v2/records`

      status 201
    end

    run! if app_file == $0
  end
end

