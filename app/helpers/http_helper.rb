require 'net/http'
require 'uri'
module HttpHelper
  def self.get_secure(path)
    uri = URI.parse(path)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = https.get(path)
    return response.body
  end
end