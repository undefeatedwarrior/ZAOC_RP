CLASS lhc_Travle DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travle RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travle RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travle.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE Travle\_Booking.

ENDCLASS.

CLASS lhc_Travle IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create. "Travel

    DATA: entity        TYPE STRUCTURE FOR CREATE zats_rp_travel,
          travel_id_max TYPE /dmo/travel_id.


    "" Step 1: Ensure that Travel id is not for the record which is coming
    LOOP AT entities INTO entity WHERE TravelId IS NOT INITIAL. "Insert data with Travel ID exist

      APPEND CORRESPONDING #( entity ) TO mapped-travle.

    ENDLOOP.

    DATA(entities_wo_travelid) = entities.
    DELETE entities_wo_travelid WHERE TravelId IS NOT INITIAL.


    "" Step 2: Get the Sequence number from the SNRO
    TRY.

        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = CONV #('/DMO/TRAVL')
            quantity          = CONV #( lines( entities_wo_travelid )  )
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_returncode)
            returned_quantity = DATA(number_range_returned_quantity)
        ).


      CATCH cx_number_ranges INTO DATA(lx_number_ranges).

        "" Step 3: If there is an exception then throw the error
        LOOP AT entities_wo_travelid INTO entity.

          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %msg = lx_number_ranges ) TO reported-travle.

          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key ) TO failed-travle.

        ENDLOOP.

        EXIT. "If error then exit the transaction

    ENDTRY.


    CASE number_range_returncode.

      WHEN '1'.
        "" Step 4: Handle especial cases where number range exceed the critical %
        LOOP AT entities_wo_travelid INTO entity.

          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %msg = NEW /dmo/cm_flight_messages(
                              textid = /dmo/cm_flight_messages=>number_range_depleted
                              severity = if_abap_behv_message=>severity-warning
                            )
                           ) TO reported-travle.

        ENDLOOP.

      WHEN '2' OR '3'.
        "" Step 5: The number range return last number , or number exhausted
        LOOP AT entities_wo_travelid INTO entity.

          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %msg = NEW /dmo/cm_flight_messages(
                              textid = /dmo/cm_flight_messages=>not_sufficient_numbers
                              severity = if_abap_behv_message=>severity-warning
                            )
                           ) TO reported-travle.

          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key ) TO failed-travle.

        ENDLOOP.

    ENDCASE.


    "" Step 6: Final Check for all numbers
    ASSERT number_range_returned_quantity = lines( entities_wo_travelid ).


    "" Step 7: Loop over the incoming level data and assign the numbers
    ""         from number range and return MAPPED data which will then go to RAP framework

    travel_id_max = number_range_key - number_range_returned_quantity. "It will get first number generated

    LOOP AT entities_wo_travelid INTO entity.

      travel_id_max = travel_id_max + 1.
      entity-TravelId = travel_id_max.


      APPEND VALUE #( %cid = entity-%cid
                      %key = entity-%key ) TO mapped-travle.


    ENDLOOP.


  ENDMETHOD.



  METHOD earlynumbering_cba_Booking. "Booking

    DATA max_booking_id TYPE /dmo/booking_id.
    "" Step 1: Get all travel requests and their booking data
    READ ENTITIES OF zats_rp_travel IN LOCAL MODE ENTITY Travle
                                    BY \_Booking
                                    FROM CORRESPONDING #( entities )
                                    LINK DATA(bookings).


    "" Loop at unique travel id
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_group>) GROUP BY <travel_group>-TravelId.

      ""Step 2: get the highest booking number which is already there
      LOOP AT bookings INTO DATA(ls_booking) USING KEY entity
                                             WHERE source-TravelId = <travel_group>-TravelId.

        IF max_booking_id < ls_booking-target-BookingId.
          max_booking_id = ls_booking-target-BookingId.
        ENDIF.

      ENDLOOP.


      ""Step 3: get the assigned booking numbers for incoming request

      LOOP AT entities INTO DATA(ls_entity) USING KEY entity
                                            WHERE TravelId = <travel_group>-TravelId.

        LOOP AT ls_entity-%target INTO DATA(ls_target).

          IF max_booking_id < ls_target-BookingId.
            max_booking_id = ls_target-BookingId.
          ENDIF.

        ENDLOOP.

      ENDLOOP.


      ""Step 4: loop over all the entities of travel with same travel id

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel>)
                       USING KEY entity WHERE TravelId = <travel_group>-TravelId.

        ""Step 5: assign new booking IDs to the booking entity inside each travel
        LOOP AT <travel>-%target ASSIGNING FIELD-SYMBOL(<booking_wo_numbers>).
                                 APPEND CORRESPONDING #( <booking_wo_numbers> )
                                 TO mapped-booking
                                 ASSIGNING FIELD-SYMBOL(<mapped_booking>).

          IF <mapped_booking>-BookingId IS INITIAL.
            max_booking_id = max_booking_id + 1 .
            <mapped_booking>-BookingId = max_booking_id.
          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.



  ENDMETHOD.

ENDCLASS.
