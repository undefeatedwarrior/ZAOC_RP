@EndUserText.label: 'TF Demo - Total sales per customer ranked'
define table function ZATS_RP_TF
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt : abap.clnt
returns
{
  client        : abap.clnt;
  company_name  : abap.char( 256 );
  total_sales   : abap.curr( 15, 2 );
  currency_code : abap.cuky(5);
  customer_rank : abap.int4; 
}
implemented by method
  ZCL_ATS_RP_AMDP=>get_total_sales;