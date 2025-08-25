CLASS zcl_rp_ats_new_abap_syntax DEFINITION

  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS: s1_inline_declaration.



  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_rp_ats_new_abap_syntax IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.


  METHOD s1_inline_declaration.

    select * from /dmo/agency into table @data(lt_agency).

    loop at lt_agency into data(wa_agency).



    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
