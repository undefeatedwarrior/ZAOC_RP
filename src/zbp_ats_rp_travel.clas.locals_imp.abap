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

  METHOD earlynumbering_create.

    "" Step 1: Ensure that Travel id is not for the record which is coming

    "" Step 2: Get the Sequence number from the SNRO

    "" Step 3: If there is an exception then throw the error

    "" Step 4: Handle especial cases where number range exceed the critical %

    "" Step 5: The number range return last number , or number exhausted

    "" Step 6: Final Check for all numbers

    "" Step 7: Loop over the incoming level data and assign the numbers
    ""         from number range and return MAPPED data which will then go to RAP framework




  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
  ENDMETHOD.

ENDCLASS.
