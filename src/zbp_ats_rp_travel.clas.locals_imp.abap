CLASS lhc_Travle DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travle RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travle RESULT result.
    METHODS copyTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travle~copyTravel.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travle RESULT result.
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




  METHOD copyTravel.

    DATA: Travels       TYPE TABLE FOR CREATE zats_rp_travel\\Travle,
          Bookings_cba  TYPE TABLE FOR CREATE zats_rp_travel\\Travle\_Booking,
          Booksuppl_cba TYPE TABLE FOR CREATE zats_rp_travel\\Booking\_BookingSupp.


    ""Step 1: Remove the travel instances with initial %cid
    READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_intial_cid).
    ASSERT key_with_intial_cid IS INITIAL.


    ""Step 2: Read all Travel, Booking & Booking Supplement data using EML
    READ ENTITIES OF zats_rp_travel IN LOCAL MODE ENTITY Travle
                                    ALL FIELDS WITH CORRESPONDING #( keys )
                                    RESULT DATA(travel_read_result)
                                    FAILED failed.

    READ ENTITIES OF zats_rp_travel IN LOCAL MODE ENTITY Travle BY \_Booking
                                    ALL FIELDS WITH CORRESPONDING #( travel_read_result )
                                    RESULT DATA(book_read_result)
                                    FAILED failed.

    READ ENTITIES OF zats_rp_travel IN LOCAL MODE ENTITY Booking BY \_BookingSupp
                                    ALL FIELDS WITH CORRESPONDING #( book_read_result )
                                    RESULT DATA(booksuppl_read_result)
                                    FAILED failed.



    LOOP AT travel_read_result ASSIGNING FIELD-SYMBOL(<travel>).

      ""Step 3: Fill Travel internal table for Travel data creation   - %cid
      APPEND VALUE #(
                      %cid = keys[ %tky = <travel>-%tky ]-%cid
                      %data = CORRESPONDING #( <travel> EXCEPT travelId )
                    )
                    TO travels ASSIGNING FIELD-SYMBOL(<new_travel>).

      <new_travel>-BeginDate      = cl_abap_context_info=>get_system_date(  ).
      <new_travel>-EndDate        = cl_abap_context_info=>get_system_date(  ) + 30.
      <new_travel>-overallstatus  = 'O'.


      ""Step 4: Fill Booking internal table for Booking data creation - %cid_ref
      APPEND VALUE #( %cid_ref = keys[ KEY entity %tky = <travel>-%tky ]-%cid )
                      TO bookings_cba ASSIGNING FIELD-SYMBOL(<bookings_cba>).

      LOOP AT book_read_result ASSIGNING FIELD-SYMBOL(<booking>) WHERE TravelId = <travel>-TravelId.

        APPEND VALUE #( %cid = keys[ KEY entity %tky = <travel>-%tky ]-%cid && <booking>-BookingId
                        %data = CORRESPONDING #( book_read_result[ KEY entity %tky = <booking>-%tky ] EXCEPT travelID )
                      )
                      TO <bookings_cba>-%target ASSIGNING FIELD-SYMBOL(<new_booking>).

        <new_booking>-BookingStatus = 'N'.


        ""Step 5: Fill Booking Supplement internal table for Booking Supplement data creation - %cid_ref
        APPEND VALUE #( %cid_ref = keys[ KEY entity %tky = <travel>-%tky ]-%cid && <booking>-BookingId )
                     TO booksuppl_cba ASSIGNING FIELD-SYMBOL(<booksuppl_cba>).

        LOOP AT booksuppl_read_result ASSIGNING FIELD-SYMBOL(<booksuppl>)
                                      USING KEY entity WHERE TravelId = <travel>-TravelId
                                                         AND BookingId = <booking>-BookingId.

          APPEND VALUE #( %cid = keys[ KEY entity %tky = <travel>-%tky ]-%cid && <booking>-BookingId && <booksuppl>-BookingSupplementId
                          %data = CORRESPONDING #(  <booksuppl> EXCEPT travelID bookingID )
                        )
                        TO <booksuppl_cba>-%target. "ASSIGNING FIELD-SYMBOL(<new_booksuppl>).


        ENDLOOP.

      ENDLOOP.

    ENDLOOP.


    ""Step 6: Modify Entity using EML to create new BO instance using existing data
    MODIFY ENTITIES OF zats_rp_travel IN LOCAL MODE

        ENTITY Travle
            CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate TotalPrice CurrencyCode ) WITH travels
            CREATE BY \_Booking  FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightPrice CurrencyCode BookingStatus ) WITH bookings_cba

        ENTITY Booking
            CREATE BY \_BookingSupp FIELDS ( BookingSupplementId SupplementId Price CurrencyCode ) WITH booksuppl_cba

        MAPPED DATA(mapped_create).

    mapped-travle = mapped_create-travle.

  ENDMETHOD.



  METHOD get_instance_features.

    ""Step 1: Read the Travel data with status
    READ ENTITIES OF zats_rp_travel IN LOCAL MODE ENTITY Travle
                                    FIELDS ( TravelId overallstatus )
                                    WITH CORRESPONDING #( keys )
                                    RESULT DATA(travels)
                                    FAILED failed.


    ""Step 2: Return the result with booking creation possible or not
    READ TABLE travels INTO DATA(ls_travel) INDEX 1.
    IF ls_travel-overallstatus = 'X'.
      DATA(lv_allow) = if_abap_behv=>fc-o-disabled.
    ELSE.
      lv_allow = if_abap_behv=>fc-o-enabled.
    ENDIF.


    result = VALUE #( FOR travel IN travels
                        ( %tky = travel-%tky
                          %assoc-_Booking = lv_allow
                        )
                    ).



  ENDMETHOD.

ENDCLASS.
