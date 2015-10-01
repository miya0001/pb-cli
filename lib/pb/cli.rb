require "pb/cli/version"
require "pb/cli/util"
require "thor"
require "rest-client"

module PB
  module Cli
    class Command < Thor
      desc "push <MESSAGE>", "Send a push to a device or another person."
      method_option :title, :aliases => "-t", :desc => "Title of the notification."
      # method_option :device, :aliases => "-d", :desc => "Target device to push."
      # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
      def push( message )
        url = "https://api.pushbullet.com/v2/pushes"
        config = PB::Cli::Utils::get_config
        RestClient.post(
          url,
          {
            "type" => "note",
            "body" => message,
            "title" => ( options[:title] ? options[:title] : "" )
          }.to_json,
          :content_type => :json,
          :accept => :json,
          "Access-Token" => config["token"]
        )
      end
    end
  end
end
