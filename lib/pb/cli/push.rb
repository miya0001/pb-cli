# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"

module Pushbullet_CLI
  class Push < Thor
    class_option :token, :desc => "Access token"

    desc "create <MESSAGE>", "Send a push to devices or another persons."
    method_option :title, :desc => "Title of the notification."
    method_option :device, :desc => "Iden of the target device to push."
    # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
    def create( message = "" )
      if File.pipe?( STDIN ) || File.select( [STDIN], [], [], 0 ) != nil then
        message = STDIN.readlines().join( "" )
      end

      url = "https://api.pushbullet.com/v2/pushes"
      token = Utils::get_token( options )

      unless message.empty?
        args = {
          "type" => "note",
          "body" => message,
          "title" => ( options[:title] ? options[:title] : "" )
        }

        unless options[:device].nil?
          unless options[:device].empty?
            args['device_iden'] = options[:device]
          end
        end

        Utils::send( url, token, "post", args )
      else
        puts "Nothing to do."
      end
    end

  end
end
