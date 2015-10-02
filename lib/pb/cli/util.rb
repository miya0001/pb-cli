# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "yaml"

module Pushbullet_CLI
  class Utils
    class << self
      def get_config
        conf = {}
        if File.exists?( File.join( ENV["HOME"], '.pb-cli/config.yml' ) )
          _custom = YAML.load(
            File.open(
              File.join( ENV["HOME"], '.pb-cli/config.yml' ),
              File::RDONLY
            ).read
          )
          conf.merge!(_custom) if _custom.is_a?(Hash)
        end
        return conf
      end

      def send( url, access_token, args )
        begin
          RestClient.post(
            url,
            args.to_json,
            :content_type => :json,
            :accept => :json,
            "Access-Token" => access_token
          )
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end
    end
  end
end
