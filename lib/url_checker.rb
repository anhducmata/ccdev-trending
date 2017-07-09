require 'rubygems'
require 'uri'
require 'net/http'
require 'net/https'

$count = 0

def url_exist?(url_str)
  $count += 1
  STDERR.puts "Checking #{url_str}..."
  status = false
  uri = URI.parse(url_str)
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true if url_str.include? ('https')
  req = Net::HTTP::Get.new(uri.request_uri)
  res = https.request(req)

  status = res.is_a?(Net::HTTPSuccess) && !res.is_a?(Net::HTTPMovedPermanently)

  if status == false && $count < 2
    if url_str.include? ('https')
      new_url = url_str.replace('https', 'http')
    else
      new_url = url_str.replace('http', 'https')
    end
    self.url_exist?(new_url)
  end
  STDERR.puts "This page founded" if status
  status
end
