require 'sinatra_app'
require 'test/unit'
require 'rack/test'
require 'helper'

set :environment, :test

class TestSwfDitty < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_swf_plain
    get '/swf_plain'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<script charset='utf-8' type='text/javascript'>$(document).ready(function(){$('#foo_swf').flash({allowScriptAccess:'sameDomain', height:'100%', name:'foo_swf', swf:'swf/foo.swf', width:'100%', wmode:'opaque'});});</script>
<div id='foo_swf' style='width:100%;height:100%'></div>
EOD
  end

  def test_swf_with_custom_dom_id
    get '/swf_with_custom_dom_id'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<script charset='utf-8' type='text/javascript'>$(document).ready(function(){$('#dombo').flash({allowScriptAccess:'sameDomain', height:'100%', name:'foo_swf', swf:'swf/foo.swf', width:'100%', wmode:'opaque'});});</script>
EOD
  end

  def test_swf_with_flashvars
    get '/swf_with_flashvars'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
<script charset='utf-8' type='text/javascript'>$(document).ready(function(){$('#foo_swf').flash({allowScriptAccess:'sameDomain', flashvars:{a:1, b:'two'}, height:50, name:'foo_swf', swf:'foo.swf', width:600, wmode:'opaque'});});</script>
<div id='foo_swf' style='width:600px;height:50px'></div>
EOD
  end

  def test_filename_to_dom_id
    get '/filename_to_dom_id'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
alpha_swf
bravo_swf
charlie_swf
EOD
  end
  
  def test_hash_to_key_value_string
    get '/hash_to_key_value_string'
    assert last_response.ok?
    assert_equal last_response.body,  <<EOD
a:1, b:2
alpha:'male', bravo:'hamster'
EOD
  end
  
end