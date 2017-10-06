require 'pry'
require_relative './url_required.rb'
require_relative './helpers_required.rb'

class Drone_Delivery < HelperFunctions
    include UrlPath

    def initialize
    # initializing empty drones & packages
      @drone = [ ]
      @packages = [ ]
      @drone = nil
      @packge = nil
    #Queues for drones and packages
    #1 adding package in queue based on deadline
      @packagesQueue = [ ]
    #2 adding drones in queue based on how quickly they can pick up their next package
      @dronesQueue = [ ]
    end
    # function for converting given deadline into read-able format(time)
    def intToTime(deadline)
       Time.at(deadline)
    end


    def fetchData
     @drones = get_drone_info
     @packages = get_package_info
     for package in @packages
      # read-able deadline
       package["deadline"]= intToTime(package["deadline"])
       distance = distance_between(DEPO,package["destination"])
      # divided by 50/km per hour drone's speed; this will return us duration, in hours
       package["deliveryTime"] = distance / DRONE_SPEED
     end
      puts @packages
    end
end

drone = Drone_Delivery.new
drone.fetchData
