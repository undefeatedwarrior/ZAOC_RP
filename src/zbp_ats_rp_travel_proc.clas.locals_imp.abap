CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE Travel.

    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD augment_create.

    DATA: travel_create TYPE TABLE FOR CREATE zats_rp_travel.

    travel_create = CORRESPONDING #( entities ).

    LOOP AT travel_create ASSIGNING FIELD-SYMBOL(<travel>).

      <travel>-AgencyId = '70002'.
      <travel>-overallstatus = 'O'.
      <travel>-%control-AgencyId = if_abap_behv=>mk-on.
      <travel>-%control-overallstatus = if_abap_behv=>mk-on.

    ENDLOOP.

    MODIFY AUGMENTING ENTITIES OF zats_rp_travel ENTITY Travle CREATE FROM travel_create.

  ENDMETHOD.

  METHOD precheck_create.
  ENDMETHOD.

  METHOD precheck_update.
  ENDMETHOD.

ENDCLASS.
