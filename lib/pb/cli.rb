# encoding: utf-8

require "pb/cli/version"
require "pb/cli/util"
require "thor"
require "rest-client"
require "yaml"

module PB
  module Cli
    class Command < Thor
      desc "push <MESSAGE>", "Send a push to devices or another persons."
      method_option :title, :aliases => "-t", :desc => "Title of the notification."
      # method_option :device, :aliases => "-d", :desc => "Target device to push."
      # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
      def push( message = "" )
        if File.pipe?(STDIN) || File.select([STDIN], [], [], 0) != nil then
          message = STDIN.gets
        end

        url = "https://api.pushbullet.com/v2/pushes"

        if message
          args = {
            "type" => "note",
            "body" => message,
            "title" => ( options[:title] ? options[:title] : "" )
          }

          Utils::send( url, args )
        else
          puts "Nothing to do."
        end
      end

      desc "init <ACCESS-TOKEN>", "Initialize pb-cli"
      def init( acccess_token )
        unless Dir.exist? File.join( ENV["HOME"], '.pb-cli' )
          FileUtils.mkdir( File.join( ENV["HOME"], '.pb-cli' ) );
        end
        File.open( File.join( ENV["HOME"], '.pb-cli', 'config.yml' ), "w" ) do | file |
            file.write( "acccess_token: " + acccess_token )
        end
        FileUtils.chmod( 0600, File.join( ENV["HOME"], '.pb-cli', 'config.yml' ) )
      end
    end
  end
end
