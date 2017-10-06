require 'pry'
require_relative './url_required.rb'
require_relative './helpers_required.rb'

class Drone_Delivery < HelperFunctions
    include UrlPath

end

drone = Drone_Delivery.new
