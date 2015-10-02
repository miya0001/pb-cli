# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'pb/cli'

describe Pushbullet_CLI::Command do
  it "Creating config file" do
    ENV["HOME"] = "/tmp"
    Pushbullet_CLI::Command.new.init( 'my_acccess_token' )
    expect( FileTest.exist?( "/tmp/.pb-cli/config.yml" ) ).to be_truthy
    config = Pushbullet_CLI::Utils::get_config
    expect( config["access_token"] ).to eq "my_acccess_token"
  end
end
