# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"

module Pushbullet_CLI
  class Device < Thor
    class_option :"access-token"

    desc "list", "Get a list of devices belonging to the current user."
    def list()
      url = "https://api.pushbullet.com/v2/devices?active=true"
      token = Utils::get_token( options )

      result = JSON.parse( Utils::send( url, token, "get" ) )
      row = result['devices'].map.with_index{ | device | [
        device['iden'],
        device['nickname'],
        device['model'],
      ] }

      Utils:: print_table( [ "Iden", "Nickname", "Model" ], row )
    end
  end
end
