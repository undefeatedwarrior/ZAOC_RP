@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Composite, Cube View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE
define view entity ZI_ATS_RP_SALES_CUBE
  as select from ZI_ATS_RP_SALES
  association [1] to zats_rp_bpa     as _BusinessPartner on $projection.Buyer = _BusinessPartner.bp_id
  association [1] to zats_rp_product as _Product         on $projection.Product = _Product.product_id
{
  key ZI_ATS_RP_SALES.OrderId,
  key ZI_ATS_RP_SALES._Items.item_id as ItemId,
      ZI_ATS_RP_SALES.OrderNo,
      ZI_ATS_RP_SALES.Buyer,
      ZI_ATS_RP_SALES.CreatedBy,
      ZI_ATS_RP_SALES.CreatedOn,

      /* Associations */
      ZI_ATS_RP_SALES._Items.product  as Product,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CurrencyCode'
      ZI_ATS_RP_SALES._Items.amount   as GrossAmount,
      ZI_ATS_RP_SALES._Items.currency as CurrencyCode,

      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      ZI_ATS_RP_SALES._Items.qty      as Quantity,
      ZI_ATS_RP_SALES._Items.uom      as UnitOfMeasure,
      _Product,
      _BusinessPartner

}
