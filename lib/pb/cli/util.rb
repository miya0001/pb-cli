# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "yaml"
require "terminal-table"

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

      def get_token( options )
        token = ""
        unless options[:token].nil?
          token = options[:token]
        else
          config = Utils::get_config
          unless config["access_token"].nil?
            token = config["access_token"]
          end
        end

        unless token.empty?
          return token
        else
          puts "Please initialize an Access Token with `pb init <ACCESS-TOKEN>`."
          exit 1
        end
      end

      def send( url, access_token, method = "post", args = {} )
        begin
          if "post" == method
            return JSON.parse( RestClient.post(
              url,
              args.to_json,
              :content_type => :json,
              :accept => :json,
              "Access-Token" => access_token
            ) )
          elsif "get" == method
            return JSON.parse( RestClient.get(
              url,
              :content_type => :json,
              :accept => :json,
              "Access-Token" => access_token
            ) )
          end
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      def print_table( headers, rows )
        puts Terminal::Table.new :headings => headers, :rows => rows
      end

    end # end self
  end # end Utils
end # end Pushbullet_CLI
