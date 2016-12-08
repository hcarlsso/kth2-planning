(define (domain Temporal-Challenge-No-Collision-Avoidance)
	(:requirements :typing :durative-actions)
	(:types turtlebot helicopter person crate crate-type waypoint - object)
	(:predicates 	

;Static predicates
		(person-at ?pers - person ?loc - waypoint)
		(crate-is-type ?crate_ - crate ?c_type - crate-type)		
		
		(isFalse ?h - helicopter)

		(occupied-waypoint ?l - waypoint)
		(connected ?from ?to - waypoint)
		(connected-area ?a1 ?a2 - area)
		
		(associated_area ?a - area ?l1 - waypoint)
		
;Dynamic predicates
	
	;Enumeration of people states (one for pre-conditions, one for goal-states)
		(person-needs ?p - person ?ct - crate-type) 
		(person-has ?p - person ?ct - crate-type)
		
	;Areas
		(area_available ?a - area)
		

	;waypoints
		(helicopter-at ?heli - helicopter ?loc - waypoint)
		(crate-at ?c - crate ?loc - waypoint)		


	;Enumeration of helicopter states..
		(helicopter-empty ?heli - helicopter)
		;As below (crate-loaded-toH ?c - crate ?h - helicopter)
		(helicopter-available ?heli - helicopter)
		(helicopter-in-area ?heli - helicopter ?a - area)

	;Enumeration of crate-states
		(crate-free-standing ?c - crate)
		(crate-loaded-toH ?c - crate ?h - helicopter)
		(crate-at-victim ?c - crate )


	;Enumeration of turlebot states..
		(turtlebot-available ?tb - turtlebot)
		(crate-loaded-toTb ?c - crate ?tb - turtlebot)
		(turtlebot-at ?tb - turtlebot ?loc - waypoint)

		(heli-landed-onTb ?h - helicopter ?tb - turtlebot)
		(turtlebot-in-area ?tb - turtlebot ?a - area)
			)

;-------------------

	;waypoint dependent fly times
	(:functions (total-cost) - number
		(fly-cost ?from ?to - waypoint) - number)

	
;------------------------------------

	;Drive turtlebot
	(:durative-action drive
		:parameters (?tb - turtlebot ?from ?to - waypoint)
		:duration (= ?duration 30)
		:condition (and
		 	(at start (turtlebot-at ?tb ?from))
			(over all (connected ?from ?to))
			(over all(connected ?from ?to))
			)

		:effect (and
			(at start (not(turtlebot-at ?tb ?from)))
		 	(at end (turtlebot-at ?tb ?to))
			)
	)

	;Drive turtlebot
	(:durative-action drive-w-heli
		:parameters (?tb - turtlebot ?h - helicopter ?from ?to - waypoint)
		:duration (= ?duration 3)
		:condition (and
		 	(at start (turtlebot-at ?tb ?from))
			(over all (connected ?from ?to))
			(over all(connected ?from ?to))
			(over all(heli-landed-onTb ?h ?tb))
			)

		:effect (and
			(at start (not(turtlebot-at ?tb ?from)))
		 	(at end (turtlebot-at ?tb ?to))
			)
	)

		

;-------------------------------------


	;Pick up crate from Turtlebot
	(:durative-action tb-pick
		:parameters (?c - crate ?tb - turtlebot ?h - helicopter ?l - waypoint)
		:duration (= ?duration 15)
		:condition	(and 

				(at start(helicopter-empty ?h))		;correct helicopter state

				(over all(turtlebot-at ?tb ?l))
				(over all(helicopter-at ?h ?l))		;correct helicopter waypoint (all the time)

				(over all(crate-loaded-toTb ?c ?tb))

				(at start (helicopter-available ?h))	;helicopter must be available
				(at start (turtlebot-available ?tb))	;tb must be available

				)
		:effect	(and 
				(at start(not(helicopter-empty ?h)))	;helicopter has updated status	
				(at end(crate-loaded-toH ?c ?h))	;helicopter-crate has updated status

				(at start(not (crate-loaded-toTb ?c ?tb)))	;crate has updated waypoint



				(at start (not(helicopter-available ?h))) 	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
				(at start (not(turtlebot-available ?tb))) 	;avoiding doing anything else to helicopter
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action
			)
	)

	;Drop off crate
	(:durative-action tb-load
		:parameters (?c - crate ?tb - turtlebot ?h - helicopter ?l - waypoint)
    		:duration (= ?duration 15)
		:condition	(and 

				(at start(crate-loaded-toH ?c ?h))	;helicopter-crate has updated status

				(over all(turtlebot-at ?tb ?l))
				(over all(helicopter-at ?h ?l))		;correct helicopter waypoint (all the time)


				(at start (helicopter-available ?h))	;helicopter must be available
				(at start (turtlebot-available ?tb))	;tb must be available

				)
		:effect	(and 
				(at start(helicopter-empty ?h))		;correct helicopter state

				(at end(crate-loaded-toTb ?c ?tb))
				
				(at start(helicopter-empty ?h))		;helicopter has updated status	
				(at end(not(crate-loaded-toH ?c ?h)))	;helicopter-crate has updated status

				(at start(crate-loaded-toTb ?c ?tb))	;crate has updated waypoint


				(at start (not(helicopter-available ?h))) 	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
				(at start (not(turtlebot-available ?tb))) 	;avoiding doing anything else to helicopter
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action

			)
	)




	;Pick up crate
	(:durative-action pick-up
		:parameters (?c - crate ?h - helicopter ?l - waypoint)
		:duration (= ?duration 15)
		:condition	(and 

				(at start(helicopter-empty ?h))		;correct helicopter state

				(at start(crate-at ?c ?l))		;correct crate waypoint
				(over all(helicopter-at ?h ?l))		;correct helicopter waypoint (all the time)
				(over all(crate-free-standing ?c))		;correct crate state

				(at start (helicopter-available ?h))	;helicopter must be available

				)
		:effect	(and 
				(at start(not(helicopter-empty ?h)))	;helicopter has updated status	
				(at end(crate-loaded-toH ?c ?h))	;helicopter-crate has updated status

				(at start(not (crate-at ?c ?l)))	;crate has updated waypoint


				(at start(not(crate-free-standing ?c)))	;crate has updated status

				(at start (not(helicopter-available ?h))) 	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
			)
	)

	;Drop off crate
	(:durative-action drop-off
		:parameters (?c - crate ?h - helicopter ?l - waypoint ?p - person ?ct - crate-type)
    		:duration (= ?duration 15)
		:condition	(and 

				(at start(crate-loaded-toH ?c ?h))	;correct helicopter-crate combo

				(over all(crate-is-type ?c ?ct))			;correct crate type
				(over all(person-needs ?p ?ct))			;person needs crate type
				(over all(helicopter-at ?h ?l))		;helicopter at right waypoint (all the time)
				(over all(person-at ?p ?l))			;person at right waypoint

				(at start (helicopter-available ?h))	;avoiding doing anything else to helicopter

				)
		:effect	(and 
				(at end(helicopter-empty ?h))		;helicopter has updated status	

				(at end(not(crate-loaded-toH ?c ?h)))	;helicopter-crate has updated status	

				(at end(crate-at-victim ?c))		;crate has updated status
				(at end(crate-at ?c ?l))		;crate has (updated) waypoint

				(at start(not(person-needs ?p ?ct)))	;person has updated status
				(at end (person-has ?p ?ct))		;person has updated status
				
				(at start (not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action

			)
	)

	
	;Fly helicopter inside area
	(:durative-action fly-short1
		:parameters (?h - helicopter ?tb - turtlebot ?from ?to - waypoint ?this_area - area)
    		;:duration (= ?duration (fly-cost ?from ?to))
		:duration (= ?duration 15)
		:condition	(and 

				(over all(turtlebot-in-area ?tb ?this_area)) 

				(at start(helicopter-at ?h ?from))	;helicopter at start-waypoint

				(at start (helicopter-available ?h))	;helicopter must be available 
				
				(at start(helicopter-in-area ?h ?this_area))	;helicopter at start-area

				(over all(associated_area ?this_area ?to))
				(over all(associated_area ?this_area ?from))

				(over all(connected ?from ?to))
				
				
				)
		:effect	(and 
				(at start(not(helicopter-at ?h ?from)))	;helicopter has updated waypoint
				(at end(helicopter-at ?h ?to))		;helicopter has updated waypoint

				
				(at start (not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
			)
	)	

;Fly helicopter inside area
	(:durative-action fly-short2
		:parameters (?h - helicopter ?tb - turtlebot ?from ?to - waypoint ?this_area - area)
    		;:duration (= ?duration (fly-cost ?from ?to))
		:duration (= ?duration 15)
		:condition	(and 

				(over all(turtlebot-in-area ?tb ?this_area)) 

				(at start(helicopter-at ?h ?from))	;helicopter at start-waypoint

				(at start (helicopter-available ?h))	;helicopter must be available 
				
				(at start(helicopter-in-area ?h ?this_area))	;helicopter at start-area

				(over all(associated_area ?this_area ?to))
				(over all(associated_area ?this_area ?from))

				(over all(connected ?to ?from))
				
				
				)
		:effect	(and 
				(at start(not(helicopter-at ?h ?from)))	;helicopter has updated waypoint
				(at end(helicopter-at ?h ?to))		;helicopter has updated waypoint

				
				(at start (not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action
				
			)
	)	

	;Land helicopter on turtlebot
	(:durative-action land-on-Tb
		:parameters (?h - helicopter ?loc - waypoint ?tb - turtlebot ?this_area - area)    		
		:duration (= ?duration 5)
		:condition	(and 
				(over all(helicopter-at ?h ?loc))	;helicopter at start-waypoint
				(at start (helicopter-available ?h))	;helicopter must be available 
				
				(over all(turtlebot-at ?tb ?loc))	;turtlebot at start-waypoint
				(at start (turtlebot-available ?tb))	;turtlebot must be available 
				
				(over all(associated_area ?this_area ?loc))

				)
		:effect	(and 
				
				(at start (not(helicopter-available ?h)))	;avoiding doing anything else to helicopter
				(at end (helicopter-available ?h))		;make sure action can start again after this action

				(at start (not(turtlebot-available ?tb)))	;avoiding doing anything else to tutlebot
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action
				
				(at end(heli-landed-onTb ?h ?tb))
				
				(at end (not(helicopter-in-area ?h ?this_area)))
				(at end (not(helicopter-at ?h ?loc)))
				
				(at end(area_available ?this_area))
			)
	)	

	;Lift helicopter from turtlebot
	(:durative-action lift-from-Tb
		:parameters (?h - helicopter ?loc - waypoint ?tb - turtlebot ?this_area - area)    		
		:duration (= ?duration 5)
		:condition	(and 
				(at start (heli-landed-onTb ?h ?tb))
				
				(over all(turtlebot-at ?tb ?loc))	;turtlebot at start-waypoint
				(at start (turtlebot-available ?tb))	;turtlebot must be available 
				
				(over all(associated_area ?this_area ?loc))

				(over all(area_available ?this_area))	;This needs to be here...


				)
		:effect	(and 
								
				(at end (helicopter-available ?h))		;make sure action can start again after this action

				(at start (not(turtlebot-available ?tb)))	;avoiding doing anything else to tutlebot
				(at end (turtlebot-available ?tb))		;make sure action can start again after this action
				
				(at end(not(heli-landed-onTb ?h ?tb)))
				
				(at start (helicopter-in-area ?h ?this_area))
				(at end (helicopter-at ?h ?loc))

				(at start(not(area_available ?this_area)))

				(at end(not(area_available ?this_area)))
			)
	)	

)

