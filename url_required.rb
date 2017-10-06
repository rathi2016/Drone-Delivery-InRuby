require 'net/http'
require 'open-uri'
require 'json'

module UrlPath

  def get_drone_info
    uri = URI.parse("https://codetest.kube.getswift.co/drones")
    response = Net::HTTP.get_response(uri)
    response.body
  end
  def get_package_info
    uri = URI.parse("https://codetest.kube.getswift.co/packages")
    response = Net::HTTP.get_response(uri)
    response.body
  end

end
