# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'pb/cli'

describe "Tests for configuration" do
  it "Creating config file" do
    ENV["HOME"] = "/tmp"
    Pushbullet_CLI::Command.new.init( 'my_acccess_token' )
    expect( FileTest.exist?( "/tmp/.pb-cli/config.yml" ) ).to be_truthy

    config = Pushbullet_CLI::Utils::get_config
    expect( config["access_token"] ).to eq "my_acccess_token"

    token = Pushbullet_CLI::Utils::get_token( {} )
    expect( token ).to eq "my_acccess_token"

    token = Pushbullet_CLI::Utils::get_token( { :"access-token" => "token_from_command" } )
    expect( token ).to eq "token_from_command"
  end
end
