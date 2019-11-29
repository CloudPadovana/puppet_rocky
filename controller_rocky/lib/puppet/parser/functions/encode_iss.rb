require 'erb'

module Puppet::Parser::Functions

  newfunction(:encode_iss, :type => :rvalue, :doc => "This function encode the OIDC ISS field") do | args |

    result = Hash.new
    result["url"] = ERB::Util.url_encode(args[0])
    if args[0].starts_with?("https://")
      result["dir"] = ERB::Util.url_encode(args[0].sub("https://", ""))
    elsif args[0].starts_with?("http://")
      result["dir"] = ERB::Util.url_encode(args[0].sub("http://", ""))
    else
      result["dir"] = result["url"]
    end

    return result

  end

end

