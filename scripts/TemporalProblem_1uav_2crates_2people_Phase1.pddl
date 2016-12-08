(define (problem TwoppC2uav3crates)
	(:domain Temporal-Challenge-No-Collision-Avoidance)
	(:objects 
		heli1 - helicopter
		tb - turtlebot		
		food_crate1 food_crate2 medicine_crate1 - crate
		person1 person2 - person 
		food medicine - crate-type 
		
		;To avoid other quadcopters
		q1 q2 q3 q4 - area 
				
		
		L00	L10	L20	L30	L40	L50	L60	L70
		L01	L11	L21	L31	L41	L51	L61	L71
		L02	L12	L22	L32	L42	L52	L62	L72
		L03	L13	L23	L33	L43	L53	L63	L73
		L04	L14	L24	L34	L44	L54	L64	L74
		L05	L15	L25	L35	L45	L55	L65	L75
		L06	L16	L26	L36	L46	L56	L66	L76
		L07	L17	L27	L37	L47	L57	L67	L77

		 - location
		
		)
	

	(:init 
	;----Static
		

		(person-at person1 L45)
		(person-at person2 L64)
		
		(crate-is-type food_crate1 food)
		(crate-is-type food_crate2 food)
		
		(crate-is-type medicine_crate1 medicine)
				

	;PRM for turtlebot
	;---------------- a is one way around obstacle

(isAdjacent	L60	L70	)
(isAdjacent	L61	L71	)
(isAdjacent	L62	L72	)
(isAdjacent	L63	L73	)
(isAdjacent	L64	L74	)
(isAdjacent	L65	L75	)
(isAdjacent	L66	L76	)
(isAdjacent	L67	L77	)

(isAdjacent	L50	L60	)
(isAdjacent	L51	L61	)
(isAdjacent	L52	L62	)
(isAdjacent	L53	L63	)
(isAdjacent	L54	L64	)
(isAdjacent	L55	L65	)
(isAdjacent	L56	L66	)
(isAdjacent	L57	L67	)

(isAdjacent	L40	L50	)
(isAdjacent	L41	L51	)
(isAdjacent	L42	L52	)
(isAdjacent	L43	L53	)
(isAdjacent	L44	L54	)
(isAdjacent	L45	L55	)
(isAdjacent	L46	L56	)
(isAdjacent	L47	L57	)

(isAdjacent	L30	L40	)
(isAdjacent	L31	L41	)
(isAdjacent	L32	L42	)
(isAdjacent	L33	L43	)
(isAdjacent	L34	L44	)
(isAdjacent	L35	L45	)
(isAdjacent	L36	L46	)
(isAdjacent	L37	L47	)
		
(isAdjacent	L20	L30	)
(isAdjacent	L21	L31	)
(isAdjacent	L22	L32	)
(isAdjacent	L23	L33	)
(isAdjacent	L24	L34	)
(isAdjacent	L25	L35	)
(isAdjacent	L26	L36	)
(isAdjacent	L27	L37	)

(isAdjacent	L10	L20	)
(isAdjacent	L11	L21	)
(isAdjacent	L12	L22	)
(isAdjacent	L13	L23	)
(isAdjacent	L14	L24	)
(isAdjacent	L15	L25	)
(isAdjacent	L16	L26	)
(isAdjacent	L17	L27	)

(isAdjacent	L00	L10	)
(isAdjacent	L01	L11	)
(isAdjacent	L02	L12	)
(isAdjacent	L03	L13	)
(isAdjacent	L04	L14	)
(isAdjacent	L05	L15	)
(isAdjacent	L06	L16	)
(isAdjacent	L07	L17	)

;---

(isAdjacent	L00	L01	)
(isAdjacent	L10	L11	)
(isAdjacent	L20	L21	)
(isAdjacent	L30	L31	)
(isAdjacent	L40	L41	)
(isAdjacent	L50	L51	)
(isAdjacent	L60	L61	)
(isAdjacent	L70	L71	)

(isAdjacent	L01	L02	)
(isAdjacent	L11	L12	)
(isAdjacent	L21	L22	)
(isAdjacent	L31	L32	)
(isAdjacent	L41	L42	)
(isAdjacent	L51	L52	)
(isAdjacent	L61	L62	)
(isAdjacent	L71	L72	)


(isAdjacent	L02	L03	)
(isAdjacent	L12	L13	)
(isAdjacent	L22	L23	)
(isAdjacent	L32	L33	)
(isAdjacent	L42	L43	)
(isAdjacent	L52	L53	)
(isAdjacent	L62	L63	)
(isAdjacent	L72	L73	)

(isAdjacent	L03	L04	)
(isAdjacent	L13	L14	)
(isAdjacent	L23	L24	)
(isAdjacent	L33	L34	)
(isAdjacent	L43	L44	)
(isAdjacent	L53	L54	)
(isAdjacent	L63	L64	)
(isAdjacent	L73	L74	)

(isAdjacent	L04	L05	)
(isAdjacent	L14	L15	)
(isAdjacent	L24	L25	)
(isAdjacent	L34	L35	)
(isAdjacent	L44	L45	)
(isAdjacent	L54	L55	)
(isAdjacent	L64	L65	)
(isAdjacent	L74	L75	)

(isAdjacent	L05	L06	)
(isAdjacent	L15	L16	)
(isAdjacent	L25	L26	)
(isAdjacent	L35	L36	)
(isAdjacent	L45	L46	)
(isAdjacent	L55	L56	)
(isAdjacent	L65	L66	)
(isAdjacent	L75	L76	)

(isAdjacent	L06	L07	)
(isAdjacent	L16	L17	)
(isAdjacent	L26	L27	)
(isAdjacent	L36	L37	)
(isAdjacent	L46	L47	)
(isAdjacent	L56	L57	)
(isAdjacent	L66	L67	)
(isAdjacent	L76	L77	)



;-----------------------------------------------------------
		

;(= (fly-cost TD T1) 4)



;------------------------------------------------------------

	;Defining area-location-mappings

(associated_area q1	L00	)
(associated_area q1	L01	)
(associated_area q1	L02	)
(associated_area q1	L03	)
(associated_area q1	L04	)
(associated_area q1	L05	)
(associated_area q1	L06	)
(associated_area q1	L07	)

(associated_area q1	L10	)
(associated_area q1	L11	)
(associated_area q1	L12	)
(associated_area q1	L13	)
(associated_area q1	L14	)
(associated_area q1	L15	)
(associated_area q1	L16	)
(associated_area q1	L17	)

(associated_area q1	L20	)
(associated_area q1	L21	)
(associated_area q1	L22	)
(associated_area q1	L23	)
(associated_area q1	L24	)
(associated_area q1	L25	)
(associated_area q1	L26	)
(associated_area q1	L27	)

(associated_area q1	L30	)
(associated_area q1	L31	)
(associated_area q1	L32	)
(associated_area q1	L33	)
(associated_area q1	L34	)
(associated_area q1	L35	)
(associated_area q1	L36	)
(associated_area q1	L37	)

(associated_area q1	L40	)
(associated_area q1	L41	)
(associated_area q1	L42	)
(associated_area q1	L43	)
(associated_area q1	L44	)
(associated_area q1	L45	)
(associated_area q1	L46	)
(associated_area q1	L47	)

(associated_area q1	L50	)
(associated_area q1	L51	)
(associated_area q1	L52	)
(associated_area q1	L53	)
(associated_area q1	L54	)
(associated_area q1	L55	)
(associated_area q1	L56	)
(associated_area q1	L57	)

(associated_area q1	L60	)
(associated_area q1	L61	)
(associated_area q1	L62	)
(associated_area q1	L63	)
(associated_area q1	L64	)
(associated_area q1	L65	)
(associated_area q1	L66	)
(associated_area q1	L67	)

(associated_area q1	L70	)
(associated_area q1	L71	)
(associated_area q1	L72	)
(associated_area q1	L73	)
(associated_area q1	L74	)
(associated_area q1	L75	)
(associated_area q1	L76	)
(associated_area q1	L77	)



	;Defining area adjancencies

		(isAdjacentArea q1 q2)
		(isAdjacentArea q1 q3)
		(isAdjacentArea q1 q4)

		(isAdjacentArea q2 q3)
		(isAdjacentArea q2 q4)

		(isAdjacentArea q3 q4)



	;Init startstate - area

		;(area_available q1)
		(area_available q2)
		(area_available q3)
		(area_available q4)

		

	;Helicopter Init
		(helicopter-available heli1)

		(helicopter-at heli1 L11)
		;(heli-landed-onTb heli2 tb)

		(helicopter-in-area heli1 q1)

		(helicopter-empty heli1)
		


	;Turtlebot Init
		(turtlebot-available tb)
		(turtlebot-at tb L00)
		(turtlebot-in-area tb q1)
		
	;---Locations to bother about..
		;NO individualized fly cost at the moment...		

		;dynamic

		(person-needs person1 food)
		(person-needs person2 food)

		;(person-needs person2 medicine)

	;Crate Init
		(crate-at food_crate1 L01)
		(crate-at food_crate2 L10)
		
		;(crate-at medicine_crate1 C2)
		;(crate-at medicine_crate2 C4)
		

		(crate-free-standing food_crate1)
		(crate-free-standing food_crate2)
		
		;(crate-free-standing medicine_crate1)
		;(crate-free-standing medicine_crate2)


	;--From Phase 1
		

	)
	
	(:goal (and 
		;(crate-loaded-toTb food_crate1 tb)
		;(crate-loaded-toTb food_crate2 tb)


		(person-has person1 food)		
		(person-has person2 food)		
				
		;(person-has person3 medicine)	
		;(person-has person4 medicine)	

		
		;(turtlebot-at tb L44)

		;(helicopter-at heli1 L01)
		;(heli-landed-onTb heli1 tb)
		
		;(crate-at-victim food_crate1)

		;(helicopter-at heli2 left_uav_forward_detour)
		;(helicopter-at heli2 LG)


		;(crate-loaded-toH food_crate1 heli1)	;correct helicopter-crate combo

		;(crate-is-type food_crate1 food)			;correct crate type
		;(person-needs person1 food)			;person needs crate type

		;(person-at person1 L45)			;person at right location
		;(helicopter-available heli1)	;avoiding doing anything else to helicopter

		)
	)

	(:metric minimize (total-cost))
)
