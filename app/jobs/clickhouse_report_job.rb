require 'net/http'
require 'openssl'

class ClickhouseReportJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    puts "[Thread #{Thread.current.object_id}] Start Request #{request_id}..."
    
    uri = URI('https://httpbin.org/delay/2')
    
    # Create the HTTP object
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    # DISABLE SSL VERIFICATION (For simulation purposes only)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # Make the request
    request = Net::HTTP::Get.new(uri)
    http.request(request)
    
    puts "[Thread #{Thread.current.object_id}] Finished Request #{request_id}"
  end
end
