# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"

module Pushbullet_CLI
  class Device < Thor
    class_option :token, :desc => "Access token"

    desc "list", "Get a list of devices belonging to the current user."
    method_option :format, :desc => "Accepted values: table, json. Default: table"
    method_option :fields, :desc => "Limit the output to specific object fields."
    def list
      url = "https://api.pushbullet.com/v2/devices?active=true"
      token = Utils::get_token( options )
      cols = [ 'iden', 'nickname', 'created' ]

      unless options[:fields].nil?
        unless options[:fields].empty?
          cols = options[:fields].split( /\s*,\s*/ )
        end
      end

      result = Utils::send( url, token, "get" )
      Utils::print( {
        :format => options[:format],
        :cols => cols,
        :rows => result['devices'],
      } )
    end # end list

  end
end
