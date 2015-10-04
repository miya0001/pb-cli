# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'pb/cli'

describe Pushbullet_CLI::Utils do

  it "Tests for note to push" do
    expect( Pushbullet_CLI::Utils::get_push_args( {} ) ).to eq "type" => "note"
    expect( Pushbullet_CLI::Utils::get_push_args( { :title => "Hello" } ) ).to eq "type" => "note", "title" => "Hello"
    expect( Pushbullet_CLI::Utils::get_push_args( { :device => "iPhone" } ) ).to eq "type" => "note", "device_iden" => "iPhone"
    expect( Pushbullet_CLI::Utils::get_push_args( { :device => "iPhone", :title => "Hello" } ) ).to eq "title" => "Hello", "type" => "note", "device_iden" => "iPhone"
  end

  it "Tests for link to push" do
    expect( Pushbullet_CLI::Utils::get_push_args( { :url => "http://example.com/" } ) ).to eq "type" => "link", "url" => "http://example.com/"
    expect( Pushbullet_CLI::Utils::get_push_args( { :title => "Hello", :url => "http://example.com/" } ) ).to eq "type" => "link", "url" => "http://example.com/", "title" => "Hello"
  end

  it "Send request" do
    result = Pushbullet_CLI::Utils::send( "https://api.pushbullet.com/v2/users/me", ENV["access_token"], "get" )
    expect( result["iden"] ).to match /^[a-zA-Z0-9]+$/
  end

  specify{ expect{
    Pushbullet_CLI::Utils::print( {
      :cols => [ "name", "age" ],
      :rows => [ { "name" => "Pitch", "email" => "jack@example.com", "age" => 17 } ]
    } )
  }.to output( /\|\s+name\s+\|\s+age\s+\|/ ).to_stdout }

  specify{ expect{
    Pushbullet_CLI::Utils::print( {
      :format => "json",
      :cols => [ "name", "age" ],
      :rows => [ { "name" => "Pitch", "email" => "jack@example.com", "age" => 17 } ]
    } )
  }.to output( '[{"name":"Pitch","email":"jack@example.com","age":17}]' + "\n" ).to_stdout }

end
