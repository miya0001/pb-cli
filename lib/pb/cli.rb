# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "pb/cli/version"
require "pb/cli/util"
require "thor"
require "rest-client"
require "yaml"

module Pushbullet_CLI
  class Command < Thor

    def self.exit_on_failure?
      true
    end

    desc "push <MESSAGE>", "Send a push to devices or another persons."
    method_option :title, :aliases => "-t", :desc => "Title of the notification."
    # method_option :device, :aliases => "-d", :desc => "Target device to push."
    # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
    def push( message = "" )
      if File.pipe?(STDIN) || File.select([STDIN], [], [], 0) != nil then
        message = STDIN.readlines().join( "" )
      end

      url = "https://api.pushbullet.com/v2/pushes"

      if message
        config = Utils::get_config

        args = {
          "type" => "note",
          "body" => message,
          "title" => ( options[:title] ? options[:title] : "" )
        }

        Utils::send( url, config['access_token'], args )
      else
        puts "Nothing to do."
      end
    end

    desc "init <ACCESS-TOKEN>", "Initialize pb-cli"
    def init( access_token )
      unless Dir.exist? File.join( ENV["HOME"], '.pb-cli' )
        FileUtils.mkdir( File.join( ENV["HOME"], '.pb-cli' ) );
      end
      File.open( File.join( ENV["HOME"], '.pb-cli', 'config.yml' ), "w" ) do | file |
          file.write( "access_token: " + access_token )
      end
      FileUtils.chmod( 0600, File.join( ENV["HOME"], '.pb-cli', 'config.yml' ) )
    end

  end # end class Command
end # end module Pushbullet_CLi
