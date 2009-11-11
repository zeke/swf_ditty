path = File.expand_path("../lib" + File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

require 'rubygems'
require 'sinatra'
require 'sinatra/swf_ditty'

get "/swf_plain" do
  content_type "text/plain"
  <<"EOD"
#{swf("swf/foo.swf")}
EOD
end

get "/swf_with_custom_dom_id" do
  content_type "text/plain"
  <<"EOD"
#{swf("swf/foo.swf", :dom_id => "dombo", :create_dom_container => false)}
EOD
end

get "/swf_with_flashvars" do
  content_type "text/plain"
  <<"EOD"
#{swf("foo.swf", :height => 50, :width => 600, :flashvars => {:a => 1, :b => 'two'})}
EOD
end

get "/filename_to_dom_id" do
  content_type "text/plain"
  <<"EOD"
#{filename_to_dom_id("alpha.swf")}
#{filename_to_dom_id("substandard/bravo.swf")}
#{filename_to_dom_id("http://bar.org/xyz/charlie.swf")}
EOD
end

get "/hash_to_key_value_string" do
  content_type "text/plain"
  <<"EOD"
#{hash_to_key_value_string({:a => 1, :b => 2})}
#{hash_to_key_value_string({:alpha => 'male', :bravo => 'hamster'})}
EOD
end