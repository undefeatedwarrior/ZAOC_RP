@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #BASIC

define view entity ZI_ATS_RP_PRODUCT
  as select from zats_rp_product
{

  key product_id as ProductId,
      name       as Name,
      category   as Category,
      @Semantics.amount.currencyCode: 'Currency'
      price      as Price,
      currency   as Currency,
      discount   as Discount

}
