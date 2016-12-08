(define (domain Temporal-Challenge-No-Collision-Avoidance)
	(:requirements :typing :durative-actions)
	(:types turtlebot helicopter person crate crate-type waypoint - object)
	(:predicates 	

;Static predicates
		(person-at ?pers - person ?loc - waypoint)
		(crate-is-type ?crate_ - crate ?c_type - crate-type)		
		
		;(isFalse ?h - helicopter)
		;(isFalse ?tb - turtlebot)

		;(occupied-waypoint ?l - waypoint)
		(connected ?from ?to - waypoint)		
		
;Dynamic predicates
	
	;Enumeration of people states (one for pre-conditions, one for goal-states)
		(person-needs ?p - person ?ct - crate-type) 
		(person-has ?p - person ?ct - crate-type)
			

	;waypoints
		(helicopter-at ?heli - helicopter ?loc - waypoint)
		(crate-at ?c - crate ?loc - waypoint)		


	;Enumeration of helicopter states..
		(helicopter-empty ?heli - helicopter)
		;As below (crate-loaded-toH ?c - crate ?h - helicopter)
		(helicopter-available ?heli - helicopter)
		(helicopter-landed ?heli - helicopter)

	
	;Enumeration of crate-states
		(crate-free-standing ?c - crate)
		(crate-loaded-toH ?c - crate ?h - helicopter)
		(crate-at-victim ?c - crate )


	;Enumeration of turlebot states..
		(turtlebot-available ?tb - turtlebot)
		(crate-loaded-totb ?c - crate ?tb - turtlebot)
		(turtlebot-at ?tb - turtlebot ?loc - waypoint)

		(heli-landed-onTb ?h - helicopter ?tb - turtlebot)	
			)

;-------------------

	;waypoint dependent fly times
	(:functions (total-cost) - number
		(fly-cost ?from ?to - waypoint) - number)

	
;------------------------------------

	;Drive turtlebot
	(:durative-action goto_waypoint ;drive
		:parameters (?tb - turtlebot ?from ?to - waypoint)
		:duration (= ?duration 30)
		:condition (and
		 	(at start (turtlebot-at ?tb ?from))
			(over all (connected ?from ?to))			
			)

		:effect (and
			(at start (not(turtlebot-at ?tb ?from)))
		 	(at end (turtlebot-at ?tb ?to))
			)
	)

	;Drive turtlebot
	(:durative-action drive-w-heli
		:parameters (?tb - turtlebot ?h - helicopter ?from ?to - waypoint)
		:duration (= ?duration 1)
		:condition (and
		 	(at start (turtlebot-at ?tb ?from))
			(over all (connected ?from ?to))		
			(over all(heli-landed-ontb ?h ?tb))
			)

		:effect (and
			(at start (not(turtlebot-at ?tb ?from)))
		 	(at end (turtlebot-at ?tb ?to))
			)
	)

		

;-------------------------------------


	;Pick up crate from Turtlebot
	(:durative-action tb-pick
		:parameters (?c - crate ?tb - turtlebot ?h - helicopter ?loc - waypoint)
		:duration (= ?duration 5)
		:condition	(and 

				(at start(helicopter-empty ?h))		;correct helicopter state

				(over all(turtlebot-at ?tb ?loc))
				(over all(helicopter-at ?h ?loc))		;correct helicopter waypoint (all the time)

				(at start(crate-loaded-totb ?c ?tb))

				(at start (helicopter-available ?h))	;helicopter must be available
				(at start (turtlebot-available ?tb))	;tb must be available

				)
		:effect	(and 
				(at start(not(helicopter-empty ?h)))	;helicopter has updated status	
				(at end(crate-loaded-toH ?c ?h))	;helicopter-crate has updated status

				(at end(not (crate-loaded-totb ?c ?tb)))	;crate has updated waypoint



				(at start (not(helicopter-available ?h))) 	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
				(at start (not(turtlebot-available ?tb))) 	;avoiding doing anything else to helicopter
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action
			)
	)

	;Drop off crate
	(:durative-action tb-load
		:parameters (?c - crate ?tb - turtlebot ?h - helicopter ?loc - waypoint)
    		:duration (= ?duration 15)
		:condition	(and 

				(at start(crate-loaded-toH ?c ?h))	;helicopter-crate has updated status

				(over all(turtlebot-at ?tb ?loc))
				(over all(helicopter-at ?h ?loc))		;correct helicopter waypoint (all the time)

				(at start (helicopter-available ?h))	;helicopter must be available
				(at start (turtlebot-available ?tb))	;tb must be available

				)
		:effect	(and 
				(at end(helicopter-empty ?h))		;correct helicopter state

				(at end(crate-loaded-totb ?c ?tb))
				
				(at end(helicopter-empty ?h))		;helicopter has updated status	
				(at end(not(crate-loaded-toH ?c ?h)))	;helicopter-crate has updated status

				(at end(crate-loaded-totb ?c ?tb))	;crate has updated waypoint


				(at start (not(helicopter-available ?h))) 	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
				(at start (not(turtlebot-available ?tb))) 	;avoiding doing anything else to helicopter
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action

			)
	)




	;Pick up crate
	(:durative-action pick-up
		:parameters (?c - crate ?h - helicopter ?loc - waypoint)
		:duration (= ?duration 15)
		:condition	(and 

				(at start(helicopter-empty ?h))		;correct helicopter state

				(at start(crate-at ?c ?loc))		;correct crate waypoint
				(over all(helicopter-at ?h ?loc))		;correct helicopter waypoint (all the time)
				(at start(crate-free-standing ?c))		;correct crate state

				(at start (helicopter-available ?h))	;helicopter must be available

				)
		:effect	(and 
				(at end(not(helicopter-empty ?h)))	;helicopter has updated status	
				(at end(crate-loaded-toH ?c ?h))	;helicopter-crate has updated status

				(at end(not (crate-at ?c ?loc)))	;crate has updated waypoint


				(at end(not(crate-free-standing ?c)))	;crate has updated status

				(at start(not(helicopter-available ?h))) 	;avoiding doing anything else to helicopter
				(at end(helicopter-available ?h))		;make sure action can start again after this action
				
			)
	)

	;Drop off crate
	(:durative-action drop-off
		:parameters (?c - crate ?h - helicopter ?loc - waypoint ?p - person ?ct - crate-type)
    		:duration (= ?duration 15)
		:condition	(and 

				(at start(crate-loaded-toH ?c ?h))	;correct helicopter-crate combo

				(over all(crate-is-type ?c ?ct))			;correct crate type
				(at start(person-needs ?p ?ct))			;person needs crate type
				(over all(helicopter-at ?h ?loc))		;helicopter at right waypoint (all the time)
				(over all(person-at ?p ?loc))			;person at right waypoint

				(at start (helicopter-available ?h))	;avoiding doing anything else to helicopter

				)
		:effect	(and 
				(at end(helicopter-empty ?h))		;helicopter has updated status	

				(at end(not(crate-loaded-toH ?c ?h)))	;helicopter-crate has updated status	

				(at end(crate-at-victim ?c))		;crate has updated status
				(at end(crate-at ?c ?loc))		;crate has (updated) waypoint

				(at end(not(person-needs ?p ?ct)))	;person has updated status
				(at end(person-has ?p ?ct))		;person has updated status
				
				(at start (not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action

			)
	)

	
	;Fly helicopter inside area
	(:durative-action fly-short
		:parameters (?h - helicopter ?tb - turtlebot ?from ?to - waypoint )
    		;:duration (= ?duration (fly-cost ?from ?to))
		:duration (= ?duration 15)
		:condition	(and 

				(at start(helicopter-at ?h ?from))	;helicopter at start-waypoint

				(at start (helicopter-available ?h))	;helicopter must be available 
				
				(over all(connected ?from ?to))
				
				)
		:effect	(and 
				(at start(not(helicopter-at ?h ?from)))	;helicopter has updated waypoint
				(at end(helicopter-at ?h ?to))		;helicopter has updated waypoint

				
				(at start (not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
			)
	)	



	;Land helicopter on turtlebot
	(:durative-action land-on-tb
		:parameters (?h - helicopter ?loc - waypoint ?tb - turtlebot)    		
		:duration (= ?duration 5)
		:condition	(and 
				(at start(helicopter-at ?h ?loc))	;helicopter at start-waypoint
				(at start(helicopter-available ?h))	;helicopter must be available 
				
				(over all(turtlebot-at ?tb ?loc))	;turtlebot at start-waypoint
				(at start(turtlebot-available ?tb))	;turtlebot must be available 
				
				)
		:effect	(and 
				
				(at start(not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end(helicopter-available ?h))		;make sure action can start again after this action

				(at start(not(turtlebot-available ?tb)))	;avoiding doing anything else to tutlebot
				(at end(turtlebot-available ?tb))		;make sure action can start again after this action
				
				(at end(heli-landed-onTb ?h ?tb))
				
				(at end(not(helicopter-at ?h ?loc)))
				
				
			)
	)	

	;Lift helicopter from turtlebot
	(:durative-action lift-from-tb
		:parameters (?h - helicopter ?loc - waypoint ?tb - turtlebot)    		
		:duration (= ?duration 5)
		:condition	(and 
				(at start (heli-landed-onTb ?h ?tb))
				
				(over all(turtlebot-at ?tb ?loc))	;turtlebot at start-waypoint
				(at start (turtlebot-available ?tb))	;turtlebot must be available 
				
				)
		:effect	(and 
								
				(at end (helicopter-available ?h))		;make sure action can start again after this action

				(at start (not(turtlebot-available ?tb)))	;avoiding doing anything else to tutlebot
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action
				
				(at end(not(heli-landed-onTb ?h ?tb)))
				
				(at end(helicopter-at ?h ?loc))

				
			)
	)





;Lift helicopter from ground
	(:durative-action lift-from-ground
		:parameters (?h - helicopter)    		
		:duration (= ?duration 500)
		:condition	(and 								
				(at start(helicopter-landed ?h))
				;(over all(helicopter-available ?h))
				)
		:effect	(and 
								
				(at end (helicopter-available ?h))	;make sure action can start again after this action
				(at end(not(helicopter-landed ?h)))
			)
	)	

		

)

