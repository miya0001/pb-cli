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
  end

  it "Pushbullet_CLI::Utils::get_config should return hash array" do
    config = Pushbullet_CLI::Utils::get_config
    expect( config["access_token"] ).to eq "my_acccess_token"
  end

  it "Pushbullet_CLI::Utils::get_token() should get a token from config file" do
    token = Pushbullet_CLI::Utils::get_token( {} )
    expect( token ).to eq "my_acccess_token"
  end

  it "Pushbullet_CLI::Utils::get_token() should get a token from parameter" do
    token = Pushbullet_CLI::Utils::get_token( { :token => "token_from_command" } )
    expect( token ).to eq "token_from_command"
  end

end

describe "Tests for API access"  do

  it "Send request" do
    result = Pushbullet_CLI::Utils::send( "https://api.pushbullet.com/v2/users/me", ENV["access_token"], "get" )
    expect( result["iden"] ).to match /^[a-zA-Z0-9]+$/
  end

  it "Pushes a message" do
    expect{
      Pushbullet_CLI::Push.new.invoke( :create, [ "Hello I'm Travis!" ], { token: ENV["access_token"] } )
    }.not_to raise_error
  end

  it "Pushes a message with title" do
    expect{
      Pushbullet_CLI::Push.new.invoke( :create, [ "Hello I'm Travis! (with title)" ], { token: ENV["access_token"], title: "Hello" } )
    }.not_to raise_error
  end

  # before do
  #   specify{ expect{
  #     Pushbullet_CLI::Command.new.invoke( :push, [ "Hello I'm Travis!" ], { token: "THISISWRONGTOKEN" } )
  #   }.to output( "401 Unauthorized\n" ).to_stderr }
  # end

  specify{ expect{
    Pushbullet_CLI::Device.new.invoke( :list, [], { token: ENV["access_token"] } )
  }.to output( /Iden.*Nickname.*Model/ ).to_stdout }

end
