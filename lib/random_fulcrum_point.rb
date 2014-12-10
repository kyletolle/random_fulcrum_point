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
      set :port, ENV['PORT']
    end

    post '/' do
      def fulcrum_api_key
        ENV['FULCRUM_API_KEY']
      end

      def fulcrum_form_id
        ENV['FULCRUM_FORM_ID']
      end

      def fulcrum_field_id
        ENV['FULCRUM_FIELD_ID']
      end

      def fulcrum_toggle_record_id
        ENV['FULCRUM_TOGGLE_RECORD_ID']
      end

      def fulcrum_toggle_field_id
        ENV['FULCRUM_TOGGLE_FIELD_ID']
      end

      def actually_create_record?
        toggle_record_string = `curl -H "Content-Type: application/json" -H "X-ApiToken: #{fulcrum_api_key}"  https://web.fulcrumapp.com/api/v2/records/#{fulcrum_toggle_record_id}.json`
        toggle_record_hash = JSON.parse(toggle_record_string)
        toggle_value = toggle_record_hash['record']['form_values'][fulcrum_toggle_field_id]

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
      random_status = statuses[rand(statuses.count)]
      payload_hash =
        {
          form_id:   fulcrum_form_id,
          latitude:  random_point[0],
          longitude: random_point[1],
          status:    random_status,
          form_values: { fulcrum_field_id => Time.now.to_i.to_s }
        }

      payload_json = JSON.generate(payload_hash)
      `curl -H "Content-Type: application/json" -H "X-ApiToken:#{fulcrum_api_key}" -d '#{payload_json}' https://web.fulcrumapp.com/api/v2/records`

      status 201
    end

    run! if app_file == $0
  end
end

