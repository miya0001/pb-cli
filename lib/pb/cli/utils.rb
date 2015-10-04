# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "yaml"
require "terminal-table"
require "date"

module Pushbullet_CLI
  class Utils
    class << self

      def parse_row( cols, row )
        table = []
        cols.each{ |col|
          if "created" == col || "modified" == col
            val = Time.at( row[col] )
          else
            val = row[col]
          end
          table.push( val )
        }
        return table
      end

      def print( args )
        if "json" == args[:format]
          puts JSON.generate( args[:rows] )
        else
          table = args[:rows].map.with_index{ | row | parse_row( args[:cols], row ) }
          Utils:: print_table( args[:cols], table )
        end
      end # end print

      def get_push_args( options )
        args = {}

        unless options[:title].nil?
          unless options[:title].empty?
            args["title"] = options[:title]
          end
        end

        unless options[:device].nil?
          unless options[:device].empty?
            args["device_iden"] = options[:device]
          end
        end

        unless options[:url].nil?
          unless options[:url].empty?
            args["url"] = options[:url]
            args["type"] = "link"
          end
        end

        if args["type"].nil?
          args["type"] = "note"
        end

        return args
      end # end get_push_args

      def get_config
        conf = {}
        if File.exists?( File.join( ENV["HOME"], '.pb-cli/config.yml' ) )
          config = YAML.load(
            File.open(
              File.join( ENV["HOME"], '.pb-cli/config.yml' ),
              File::RDONLY
            ).read
          )
          conf.merge!( config ) if config.is_a?(Hash)
        end
        return conf
      end # end get_config

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
          $stderr.puts "Please initialize an Access Token with `pb init <ACCESS-TOKEN>` or run command with `--token=<ACCESS-TOKEN>`."
          exit 1
        end
      end # end get_token

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
      end # end send

      def print_table( headers, rows )
        puts Terminal::Table.new :headings => headers, :rows => rows
      end # end print_table

    end # end self
  end # end Utils
end # end Pushbullet_CLI
