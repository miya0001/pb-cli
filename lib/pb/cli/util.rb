# encoding: utf-8
require "yaml"

module PB
  module Cli
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

        def send( url, args )
          config = get_config
          RestClient.post(
            url,
            args.to_json,
            :content_type => :json,
            :accept => :json,
            "Access-Token" => config["acccess_token"]
          )
        end
      end
    end
  end
end
