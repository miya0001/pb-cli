# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"

module Pushbullet_CLI
  class Push < Thor
    class_option :token, :desc => "Access token"

    desc "create <MESSAGE>", "Send a push to devices or another persons."
    method_option :title, :desc => "Title of the notification."
    method_option :device, :desc => "Iden of the target device to push."
    method_option :url, :desc => "The url to open."
    # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
    def create( message = "" )
      if File.pipe?( STDIN ) || File.select( [STDIN], [], [], 0 ) != nil then
        message = STDIN.readlines().join( "" )
      end

      url = "https://api.pushbullet.com/v2/pushes"
      token = Utils::get_token( options )

      unless message.empty?
        args = Utils::get_push_args( options )
        args['body'] = message
        Utils::send( url, token, "post", args )
      else
        puts "Nothing to do."
      end
    end # end create

    desc "list", "Request push history."
    method_option :format, :desc => "Accepted values: table, json. Default: table"
    method_option :fields, :desc => "Limit the output to specific object fields."
    def list
      url = "https://api.pushbullet.com/v2/pushes?active=true"
      token = Utils::get_token( options )
      cols = [ 'iden', 'type', 'title', 'created' ]

      unless options[:fields].nil?
        unless options[:fields].empty?
          cols = options[:fields].split( /\s*,\s*/ )
        end
      end

      result = Utils::send( url, token, "get" )
      Utils::print( {
        :format => options[:format],
        :cols => cols,
        :rows => result['pushes'],
      } )
    end # end list

  end
end

# curl --header 'Access-Token: VeoW8P4oMACU46KXMYAA4f1ahIpRvB4E' \
# --data active=true \
# --get \
# https://api.pushbullet.com/v2/pushes
