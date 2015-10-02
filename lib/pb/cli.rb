# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "pb/cli/version"
require "pb/cli/util"
require "pb/cli/device"
require "thor"
require "rest-client"
require "yaml"

module Pushbullet_CLI
  class Command < Thor
    class_option :token, :desc => "Access token"

    desc "push <MESSAGE>", "Send a push to devices or another persons."
    method_option :title, :desc => "Title of the notification."
    method_option :device, :desc => "Iden of the target device to push."
    # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
    def push( message = "" )
      if File.pipe?( STDIN ) || File.select( [STDIN], [], [], 0 ) != nil then
        message = STDIN.readlines().join( "" )
      end

      url = "https://api.pushbullet.com/v2/pushes"
      token = Utils::get_token( options )

      if message
        args = {
          "type" => "note",
          "body" => message,
          "title" => ( options[:title] ? options[:title] : "" )
        }

        if options[:device]
          args['device_iden'] = options[:device]
        end

        Utils::send( url, token, "post", args )
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

    desc "device <SUBCOMMAND>", "Manage devices."
    subcommand "device", Device
  end # end class Command
end # end module Pushbullet_CLi
