# GetSwift CodeTest Analysis

**Given Scenario:**
You run a drone delivery company. Packages arrive at your depo to be delivered by your fleet of drones.

**Language Used:** Ruby (2.3.0p0)
Make sure you have Ruby installed

**Run**
ruby drone_delivery.rb

**Files**
- helpers_required.rb: includes all the required helper function you need to run drone_delivery system.
- url_required.rb: separate module holding the functionality of calling API's which gets called inside drone_delivery.rb file when required.

# Analysis

**How did you implement your solution?**
Upon receiving the JSON data for the drones and packages I used two separate methods descrbed below:

**packagesSorting**
- This determines how long it will take for each package to be delivered (distance from the depo to the destination multiplied by the drone speed of 50km/hr) is used to find the latest possible time (departBy) the package can leave the depo in order to reach the given destination before the deadline. Ones departBy time is calculated for each package I sorted packages based on delivery priority.

**dronesSorting**
- I then determined how long it will take for each drone to come back to the depo. I used if else statements which takes takes into account if the drone currently has a package and its distance from the depot. With this information I calculated
the return time (nextPackageTime) of the drone and sorted based on proximity to the depo.

**assignPackage**

- Finally, I match drones to packages by iterating through the queue of packages to match the first priority package to the first available drone. If the package delivery deadline cannot be met, the package remains unassigned from the queue.

**Why did you implement it this way?**

- Prior to running this code, we do not know the supply and demand of drones and packages. In this scenario its sorted based on when the drone is available and at what time the package needs to leave the depo. This allowed for efficient sorting of large sets into queues that ensure the highest priority package is always the first to leave the depo.

**Let's assume we need to handle dispatching thousands of jobs per second to thousands of drivers. Would the solution you've implemented still work? Why or why not? What would you modify? Feel free to describe a completely different solution than the one you've developed.**

-Yes, this code can ,handle dispatching thousands of jobs per second to thousands of drivers, since it is designed to handle a variable supply of drones and packages. In a production environment, I would assign additional time for drop off and pick up of packages. Additional examples of variables to take into account are, different drone speeds, weather conditions, and other risk categories.
Additionally logic should also be written in to handle the unassigned packages, which currently are not handled in this code as they do no meet the deadlines prescribed.
