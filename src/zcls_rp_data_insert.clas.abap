CLASS zcls_rp_data_insert DEFINITION PUBLIC.


  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    DATA: it_zats_rp_region TYPE TABLE OF zats_rp_region,
          wa_zats_rp_region LIKE LINE OF it_zats_rp_region.

    METHODS setData.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCLS_RP_DATA_INSERT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    setdata( ).
  ENDMETHOD.


  METHOD setData.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'AF'.
    wa_zats_rp_region-regionname = 'Africa'.
    append wa_zats_rp_region to it_zats_rp_region.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'AN'.
    wa_zats_rp_region-regionname = 'Antarctica'.
    append wa_zats_rp_region to it_zats_rp_region.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'APJ'.
    wa_zats_rp_region-regionname = 'Asia Pacific Japan'.
    append wa_zats_rp_region to it_zats_rp_region.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'EMEA'.
    wa_zats_rp_region-regionname = 'Europe Middle East Africa'.
    append wa_zats_rp_region to it_zats_rp_region.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'NA'.
    wa_zats_rp_region-regionname = 'North America'.
    append wa_zats_rp_region to it_zats_rp_region.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'OC'.
    wa_zats_rp_region-regionname = 'Oceania'.
    append wa_zats_rp_region to it_zats_rp_region.

    clear wa_zats_rp_region.
    wa_zats_rp_region-region = 'SA'.
    wa_zats_rp_region-regionname = 'South America'.
    append wa_zats_rp_region to it_zats_rp_region.


    insert zats_rp_region from table @it_zats_rp_region.

  ENDMETHOD.
ENDCLASS.
