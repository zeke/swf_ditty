require 'sinatra/base'

module Sinatra
  module SwfDitty
        
    def render_swf(swf, *args)
      options = {
        :swf => swf,
        :dom_id => filename_to_dom_id(swf),
        :name => filename_to_dom_id(swf),
        :width => "100%",
        :height => "100%",
        :wmode => "opaque",
        :allowScriptAccess => "sameDomain",
        :create_dom_container => true,
      }.merge(args.extract_options!)
    
      out = []
    
      # Yank dom_id out of the options hash
      dom_id = options.delete(:dom_id)
    
      # Yank create_dom_container option out of the hash, if it exists
      # Create DOM container if option is set to something other than false or nil
      out << content_tag(:div, "", :id => dom_id) if options.delete(:create_dom_container)
    
      # Turn flashvars hash into a flashvars-style formatted string
      options[:flashvars] = "{" + hash_to_key_value_string(options[:flashvars]) + "}" if options[:flashvars]
    
      # Format options hash (excluding flashvars) into a key:value string..
      embed = hash_to_key_value_string(options)
    
      # Spit it out!
      out << content_tag(:script, "$(document).ready(function(){$('##{dom_id}').flash({#{embed}});});", :type => "text/javascript", :charset => "utf-8")
      out.reverse.join("\n")
    end
  
    # Convert a string to dom-friendly format.
    # Adapted from permalink_fu
    def filename_to_dom_id(str)
      result = str.split("/").last.gsub(".", "_") # e.g. 'foo.swf' -> 'foo_swf'
      result.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      result.gsub!(/[^\w \-]+/i, '') # Remove unwanted chars.
      result.gsub!(/[ \-]+/i, '-') # No more than one of the separator in a row.
      result.gsub!(/^\-|\-$/i, '') # Remove leading/trailing separator.
      result.downcase
    end

    # Convert a hash to a string of k:v pairs, delimited by commas
    # Wrap in quotes unless numeric or flashvars hash
    def hash_to_key_value_string(hash)
      hash.each_pair.map do |k,v|
        v = "'#{v}'" unless k.to_s=='flashvars' || !v.to_s.match(/^[0-9]*\.[0-9]+|[0-9]+$/).nil?
        "#{k}:#{v}"
      end.sort.join(", ")
    end
  
    # Sinatra doesn't have this method, but Rails does..
    unless method_defined?(:content_tag)
      def content_tag(name,content,options={})
        options = options.map{ |k,v| "#{k}='#{v}'" }.join(" ")
        "<#{name} #{options}>#{content}</#{name}>"
      end
    end

    # Add these methods to Sinatra's helper methods..
    helpers SwfDitty
  end
end

class Hash
  # Sinatra doesn't have this method, but Rails does..
  unless method_defined?(:symbolize_keys)
    def symbolize_keys
      self.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
    end
  end
end

class Array
  # Sinatra doesn't have this method, but Rails does..
  unless method_defined?('extract_options!')
    def extract_options!
      last.is_a?(::Hash) ? pop : {}
    end
  end
end