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

    def packagesSorting
     @packages = get_package_info
     for package in @packages
     # read-able deadline
       distance = distance_between(DEPO,package["destination"])
     # divided by 50/km per hour drone's speed; this will return us duration, in hours
       package["deliveryTime"] = distance / DRONE_SPEED
     # if we know how long it will take to deliver the package and we know its delivery deadline
		 # we can calculate what time the package needs to leave the depo in order to arrive within the deadline
		 # i:e deadline minus deliveryTime (in milliseconds)
       package["DepartBy"] = package["deadline"] - package["deliveryTime"]
       package["deadline"]= intToTime(package["deadline"])
     end
      @packagesQueue = sorting(@packages, "DepartBy");
    end

    def dronesSorting
      @drones = get_drone_info

    end


end

drone = Drone_Delivery.new
drone.fetchData
