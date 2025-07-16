CLASS zcl_rp_mission_mars DEFINITION

  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: itab TYPE TABLE OF string.
    METHODS reach_to_mars.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_rp_mission_mars IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    me->reach_to_mars( ).
    out->write(
      EXPORTING
        data   = itab
*        name   =
*      RECEIVING
*        output =
    ).

  ENDMETHOD.


  METHOD reach_to_mars.

    data lv_text type string.
    data(lo_earth) = new zlcl_earth(  ).
    data(lo_iplanet1) = new zlcl_planet1( ).
    data(lo_mar) = new zlcl_mars( ).


    clear lv_text.
    lv_text = lo_earth->start_engine( ).
    append lv_text to itab.

    clear lv_text.
    lv_text = lo_earth->leave_orbit( ).
    append lv_text to itab.

    clear lv_text.
    lv_text = lo_iplanet1->enter_orbit( ).
    append lv_text to itab.

    clear lv_text.
    lv_text = lo_iplanet1->leave_orbit( ).
    append lv_text to itab.

    clear lv_text.
    lv_text = lo_mar->enter_orbit( ).
    append lv_text to itab.

    clear lv_text.
    lv_text = lo_mar->explore_mars( ).
    append lv_text to itab.


  ENDMETHOD.

ENDCLASS.
