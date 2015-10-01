require "pb/cli/version"
require "pb/cli/util"
require "thor"
require "rest-client"
require "yaml"

module PB
  module Cli
    class Command < Thor
      desc "push <MESSAGE>", "Send a push to a device or another person."
      method_option :title, :aliases => "-t", :desc => "Title of the notification."
      # method_option :device, :aliases => "-d", :desc => "Target device to push."
      # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
      def push( message = "" )
        if File.pipe?(STDIN) || File.select([STDIN], [], [], 0) != nil then
          message = STDIN.gets
        end

        url = "https://api.pushbullet.com/v2/pushes"

        args = {
          "type" => "note",
          "body" => message,
          "title" => ( options[:title] ? options[:title] : "" )
        }

        Utils::send( url, args )
      end
    end
  end
end
