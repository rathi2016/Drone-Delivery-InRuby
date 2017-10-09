require 'pry'
require_relative './url_required.rb'
require_relative './helpers_required.rb'

class Drone_Delivery < HelperFunctions
 include UrlPath

    def initialize
      #Queues for drones and packages
      #1 adding package in queue based on deadline
      @packagesQueue = [ ]
      #2 adding drones in queue based on how quickly they can pick up their next package
      @dronesQueue = [ ]
      # calling package sorting function
      packagesSorting
      # calling drone sorting functionand sorting is done
      dronesSorting
    end

    def packagesSorting
     @packages = get_package_info
     # loop going through each individual package information
     for package in @packages
       # read-able deadline
       distance = distance_between(DEPO,package["destination"])
       package["deadline"]= intToTime(package["deadline"])
       # divided by 50/km per hour drone's speed; this will return us duration, in hours
       package["deliveryTime"] = (distance / DRONE_SPEED)*60*60

       # if we know how long it will take to deliver the package and we know its delivery deadline
		   # we can calculate what time the package needs to leave the depo in order to arrive within the deadline
		   # i:e deadline minus deliveryTime (in milliseconds)
       package["departBy"] = package["deadline"] - package["deliveryTime"]

     end
      @packagesQueue = sorting(@packages, "departBy")
    end

    # function which calculate how quickly a drone can pick up its next package
    def dronesSorting
      @drones = get_drone_info
      # loop for going through information of each individual drone
      for drone in @drones
        # how much time from now will the drone be able to pick up another package
        @nextPackageTime = 1
        # how much time will it take to get from next destination to depot
				# allows next destination to be the depot
        @depotTime = 1
        # how long to get back to the depot after next destination
				@depotDistance = 1
        # if it has a package, calculate when it will drop the package off
			  # based on the package destination and where the drone is currently
			  # after that's calculated determine how long it will take to get back to the depo
        if drone["packages"].length > 0
          package = drone["packages"][0]
          # how many kilometers does the drone have to travel
          @dropOfdistance = distance_between(drone["location"],package["destination"])
          # how much time required to drop off
          @dropOfTime = @dropOfdistance / DRONE_SPEED
          # how many km between the package dest and the depo
          @depotDistance = distance_between(package["destination"],DEPO)
          # how much time it will take to get back to the depo after dropping off the package
          @depotTime = @depotDistance / DRONE_SPEED
          # how much time will it take for the drone to get back to depo
          @nextPackageTime = @dropOfTime + @depotTime

        else
          # we're assuming the drone is heading back to the depot to pickup
          @depotDistance = distance_between(drone["location"],DEPO)
          # how much time will it take to get back to the depo
          @depotTime = @depotDistance / DRONE_SPEED
          @nextPackageTime = @depotTime
        end
         drone["nextPackageTime"] = @nextPackageTime*60*60
        #  drone["canLeaveDepoAt"]= intToTime(drone["nextPackageTime"] + Time.now.to_f)
      end
      # adding drones into queue sorted by canLeaveDepoAt
      @dronesQueue = sorting(@drones, "nextPackageTime")
    end
    # Function to match the closest drones to the quickest package deadlines assuming that the deadline can be met
		# when the drone gets to the depo, calculate how long it will take for it to deliver each package
		# if it can deliver before the deadline and its delivery is the quickest, assign
    def assignPackage
        while (@packagesQueue.length != 0)
        package = @packagesQueue.shift
        drone = @dronesQueue.shift
        @canLeaveDepoAt = intToTime(drone["nextPackageTime"] + Time.now.to_f)
        if (package["departBy"] > @canLeaveDepoAt)
          SOLUTION["assignments"].push({
     						droneId: drone["droneId"],
     						packageId: package["packageId"]
     					})
            else
              SOLUTION["unassignedPackageIds"].push(package["packageId"])
        end
      end
    end

    def solution
      assignPackage
       print SOLUTION
    end

end

delivery = Drone_Delivery.new
delivery.solution
