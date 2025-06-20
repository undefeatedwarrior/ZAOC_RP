CLASS zcl_ats_rp_eml DEFINITION

  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    DATA: lv_opr TYPE c VALUE 'R'.




  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_ats_rp_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CASE lv_opr.

      WHEN 'R'.

        READ ENTITIES OF zats_rp_travel
        ENTITY Travle
        ALL FIELDS
*        FIELDS ( travelid agencyid CustomerId OverallStatus )
        WITH VALUE #( ( TravelId = '00000010')
                      ( TravelId = '00000026')
                      ( TravelId = '009595' )
                    )
        RESULT DATA(lt_result)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_messages) .

        out->write(
          EXPORTING
            data   = lt_result
        ).


        out->write(
          EXPORTING
            data   = lt_failed
        ).


      WHEN 'C'.

        DATA(lv_description) = 'RAP'.
        DATA(lv_agency) = '230497'.
        DATA(lv_customer) = '230400'.

        MODIFY ENTITIES OF zats_rp_travel
        ENTITY Travle
        CREATE FIELDS ( TravelId AgencyId CurrencyCode BeginDate EndDate Description overallstatus )
        WITH VALUE #( ( %cid = 'ABCDEF'
                        TravelId = '09876543'
                        AgencyId = lv_agency
                        CurrencyCode = lv_customer
                        BeginDate = cl_abap_context_info=>get_system_date( )
                        EndDate = cl_abap_context_info=>get_system_date( ) + 30
                        Description = lv_description
                        overallstatus = 'P'
                        )
                        ( %cid = 'ABCDEF1'
                        TravelId = '00001135'
                        AgencyId = lv_agency
                        CurrencyCode = lv_customer
                        BeginDate = cl_abap_context_info=>get_system_date( )
                        EndDate = cl_abap_context_info=>get_system_date( ) + 30
                        Description = lv_description
                        overallstatus = 'P'
                        )
                        ( %cid = 'ABCDEF2'
                        TravelId = '00000010'
                        AgencyId = lv_agency
                        CurrencyCode = lv_customer
                        BeginDate = cl_abap_context_info=>get_system_date( )
                        EndDate = cl_abap_context_info=>get_system_date( ) + 30
                        Description = lv_description
                        overallstatus = 'P'
                        )
                    )
         FAILED DATA(lt_fail_i)
         REPORTED DATA(lt_reported_i)
         MAPPED DATA(lt_mapped_i).

        COMMIT ENTITIES.

        out->write(
          EXPORTING
            data   = lt_mapped_i
        ).

        out->write(
          EXPORTING
            data   = lt_reported_i
        ).

        out->write(
          EXPORTING
            data   = lt_fail_i
        ).

      WHEN 'U'.

        lv_description = 'Updated Record'.
        lv_agency = '070032'.

        MODIFY ENTITIES OF zats_rp_travel
        ENTITY Travle
        UPDATE FIELDS ( AgencyId Description )
        WITH VALUE #( ( TravelId = '00001133' AgencyId = lv_agency Description = lv_description )
                      ( TravelId = '00001135' AgencyId = lv_agency Description = lv_description )
                    )
         FAILED DATA(lt_fail_u)
         REPORTED DATA(lt_reported_u)
         MAPPED DATA(lt_mapped_u).

        COMMIT ENTITIES.

        out->write(
          EXPORTING
            data   = lt_reported_u
        ).

        out->write(
          EXPORTING
            data   = lt_mapped_u
        ).

        out->write(
          EXPORTING
            data   = lt_fail_u
        ).



      WHEN 'D'.

        MODIFY ENTITIES OF zats_rp_travel
            ENTITY Travle
            DELETE FROM VALUE #(
                            ( TravelId = '00001000'
                             )
             )
         FAILED DATA(lt_fail_d)
         REPORTED DATA(lt_reported_d)
         MAPPED DATA(lt_mapped_d).

        COMMIT ENTITIES.

        out->write(
         EXPORTING
           data   = lt_mapped_d
       ).

        out->write(
          EXPORTING
            data   = lt_fail_d
        ).


    ENDCASE.

  ENDMETHOD.


ENDCLASS.
