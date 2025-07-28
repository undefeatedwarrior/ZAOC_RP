CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE Booking\_Bookingsupp.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA max_booking_suppl_id TYPE /dmo/booking_supplement_id.

    ""Step 1: get all the travel requests and their booking suppl data
    READ ENTITIES OF zats_rp_travel IN LOCAL MODE
                                    ENTITY booking BY \_BookingSupp
                                    FROM CORRESPONDING #( entities )
                                    LINK DATA(booking_supplements).

    ""Loop at unique travel ids
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

      ""Step 2: get the highest booking supplement number which is already there
      LOOP AT booking_supplements INTO DATA(ls_booking) USING KEY entity
                                  WHERE source-TravelId = <booking_group>-TravelId AND
                                        source-BookingId = <booking_group>-BookingId.

        IF max_booking_suppl_id < ls_booking-target-BookingSupplementId.
          max_booking_suppl_id = ls_booking-target-BookingSupplementId.
        ENDIF.

      ENDLOOP.


      ""Step 3: get the assigned booking supplement numbers for incoming request
      LOOP AT entities INTO DATA(ls_entity) USING KEY entity
                       WHERE TravelId = <booking_group>-TravelId AND
                             BookingId = <booking_group>-BookingId.
        LOOP AT ls_entity-%target INTO DATA(ls_target).
*          IF max_booking_suppl_id < ls_target-BookingId.
*            max_booking_suppl_id = ls_target-BookingId.
*          ENDIF.
          IF max_booking_suppl_id < ls_target-BookingSupplementId.
            max_booking_suppl_id = ls_target-BookingSupplementId.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
      ""Step 4: loop over all the entities of travel with same travel id
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>)
          USING KEY entity WHERE TravelId = <booking_group>-TravelId AND
                                 BookingId = <booking_group>-BookingId..
        ""Step 5: assign new booking IDs to the booking entity inside each travel
        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<bookingsuppl_wo_numbers>).
          APPEND CORRESPONDING #( <bookingsuppl_wo_numbers> ) TO mapped-booksuppl
          ASSIGNING FIELD-SYMBOL(<mapped_bookingsuppl>).
          IF <mapped_bookingsuppl>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id = max_booking_suppl_id + 1.
            <mapped_bookingsuppl>-BookingSupplementId = max_booking_suppl_id.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
