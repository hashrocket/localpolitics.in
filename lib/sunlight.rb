require 'rubygems'
require 'json'
require 'cgi'
require 'ym4r/google_maps/geocoding'
require 'net/http'
include Ym4r::GoogleMaps

module Sunlight

  API_URL = "http://services.sunlightlabs.com/api/"
  API_FORMAT = "json"

  attr_writer :api_key
  def api_key
    @api_key or raise "Missing Sunlight Labs API key"
  end

  # Houses general methods to work with the Sunlight and Google Maps APIs
  class SunlightObject


    # Constructs a Sunlight API-friendly URL
    def self.construct_url(api_method, params)
      url_params = params.is_a?(Array) ? array2get(params) : hash2get(params)
      "#{API_URL}#{api_method}.#{API_FORMAT}?apikey=#{Sunlight.api_key}#{url_params}"
    end


    # Converts an array to a GET string
    def self.array2get(a)
      get_string = ""
      a.each do |hash|
        get_string += hash2get(hash)
      end
      get_string
    end # def hash2get

    # Converts a hash to a GET string
    def self.hash2get(h)

      get_string = ""

      h.each_pair do |key, value|
        get_string += "&#{key.to_s}=#{CGI::escape(value.to_s)}"
      end

      get_string

    end # def hash2get


    # Use the Net::HTTP and JSON libraries to make the API call
    #
    # Usage:
    #   District.get_json_data("http://someurl.com")    # returns Hash of data or nil
    def self.get_json_data(url)

      response = Net::HTTP.get_response(URI.parse(url))
      if response.class == Net::HTTPOK
        result = JSON.parse(response.body)
      else
        nil
      end

    end # self.get_json_data



  end # class SunlightObject

end # module Sunlight

Dir["#{File.dirname(__FILE__)}/sunlight/*.rb"].each { |source_file| require source_file }
