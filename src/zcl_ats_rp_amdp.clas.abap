CLASS zcl_ats_rp_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .


    CLASS-METHODS add_numbers IMPORTING VALUE(a)      TYPE i
                                        VALUE(b)      TYPE i
                              EXPORTING
                                        VALUE(result) TYPE i.

    CLASS-METHODS get_customer IMPORTING VALUE(i_bp_id) TYPE zats_rp_dte_id
                               EXPORTING VALUE(e_res)   TYPE char40.



    CLASS-METHODS get_product_mrp IMPORTING VALUE(i_tax) TYPE i
                                  EXPORTING VALUE(otab)  TYPE zats_rp_tt_product_mrp.



    CLASS-METHODS get_total_sales FOR TABLE FUNCTION zats_rp_tf.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_rp_amdp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    zcl_ats_rp_amdp=>add_numbers(
*      EXPORTING
*        a      = 10
*        b      = 20
*      IMPORTING
*        result = DATA(lv_res)
*    ).
*
*    out->write(
*      EXPORTING
*        data   = lv_res
*
*    ).


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    zcl_ats_rp_amdp=>get_customer(
*      EXPORTING
*        i_bp_id = '426BF8BC86351FD08DF41B964D49376D'
*      IMPORTING
*        e_res   = DATA(lv_res)
*    ).
*
*    out->write(
*      EXPORTING
*        data   = lv_res
*
*    ).



    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""


*    zcl_ats_rp_amdp=>get_product_mrp(
*      EXPORTING
*        i_tax = 10
*      IMPORTING
*        otab  = data(lt_res)
*    ).
*
*
*
*    out->write(
*      EXPORTING
*        data   = lt_res
*    ).





    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""





  ENDMETHOD.




  METHOD add_numbers BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY.

    DECLARE x INTEGER;
    DECLARE y INTEGER;

    x := :a;
    y := :b;

    result := :x + :y;

  ENDMETHOD.





  METHOD get_customer BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
                                                                       USING zats_rp_bpa.

    select company_name into e_res from zats_rp_bpa where bp_id = :i_bp_id;

  ENDMETHOD.





  METHOD get_product_mrp BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
                                                                          USING zats_rp_product.

*Declare Variable

    DECLARE lv_count INTEGER;
    DECLARE i INTEGER;
    DECLARE lv_mrp BIGINT;
    DECLARE lv_price_d INTEGER;



*Get all the products in implicit table (like a internal table)

    lt_prod = select * from zats_rp_product;


*Get the record count of the table records

    lv_count := record_count( :lt_prod );


*Loop at each record one by one and calculate the price after discount (DB Table)

    for i in 1..:lv_count do

*Calculate MRP based on input TAX

        lv_price_d := :lt_prod.price[i] * ( ( 100 - :lt_prod.discount[i] )  / 100 ) ;
        lv_mrp :=  :lv_price_d * ( 100 + :i_tax ) / 100;

*if MRP is more than 15K, an additonal 10% discount to be applied

        if lv_mrp > 15000 then
            lv_mrp := :lv_mrp * 0.9;
        end if ;


*Fill thr OTAB result (like fill internal table with data)

        :otab.insert( (
                                  :lt_prod.name[i],
                                  :lt_prod.category[i],
                                  :lt_prod.price[i],
                                  :lt_prod.currency[i],
                                  :lt_prod.discount[i],
                                  :lv_price_d,
                                  :lv_mrp
                                  ), i );

                                         END FOR ;


  ENDMETHOD.





  METHOD get_total_sales BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
                                                                         USING zats_rp_bpa zats_rp_so_hdr zats_rp_so_item.


    return SELECT bpa.client,
           bpa.company_name,
           sum( item.amount ) as total_sales,
           item.currency as currency_code,
           RANK ( ) OVER ( ORDER by sum ( item.amount ) DESC ) as customer_rank
            from zats_rp_bpa as bpa
            inner join zats_rp_so_hdr as sls
            on bpa.bp_id = sls.buyer
            inner join zats_rp_so_item as item
            on sls.order_id = item.order_id
            group by bpa.client,
            bpa.company_name,
            item.currency;


  endmethod.

ENDCLASS.
