# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "pb/cli/version"
require "pb/cli/utils"
require "pb/cli/device"
require "pb/cli/push"
require "thor"
require "rest-client"
require "yaml"

module Pushbullet_CLI
  class Command < Thor
    class_option :token, :desc => "Your access token for Pushbullet API."

    desc "init <ACCESS-TOKEN>", "Writes access token into your config file."
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

    desc "push <SUBCOMMAND>", "Send or manage notifications."
    subcommand "push", Push

  end # end class Command
end # end module Pushbullet_CLi
