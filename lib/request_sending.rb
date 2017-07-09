require 'uri'
require 'net/http'
require 'net/https'

class RequestSending

  def init_http(method, endpoint, params, body)
    url_string = method == 'GET' ? "#{endpoint}?#{params}" : endpoint
    uri = URI.parse(url_string)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    case method
    when 'POST', 'post'
      req = Net::HTTP::Post.new(uri.request_uri)
    when 'GET', 'get'
      req = Net::HTTP::Get.new(uri.request_uri)
    end
    req.body = body
    res = https.request(req)
    res.is_a?(Net::HTTPSuccess) ? res.body : nil
  end

  def get(endpoint, params = {}, body = nil)
    init_http('GET', endpoint, params, body)
  end

  def post(endpoint, params = {}, body = nil)
    init_http('POST', endpoint, params, body)
  end

end
