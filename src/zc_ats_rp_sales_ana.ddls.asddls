@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Analytics Consumption View'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.query: true
define view entity ZC_ATS_RP_SALES_ANA
  as select from ZI_ATS_RP_SALES_CUBE
{
      @AnalyticsDetails.query.axis: #ROWS
  key _BusinessPartner.company_name,
      @AnalyticsDetails.query.axis: #ROWS
  key _BusinessPartner.country,
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @AnalyticsDetails.query.axis: #COLUMNS
      GrossAmount,
      @AnalyticsDetails.query.axis: #ROWS
      @Consumption.filter.selectionType: #SINGLE
      CurrencyCode,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      @AnalyticsDetails.query.axis: #COLUMNS
      Quantity,
      @AnalyticsDetails.query.axis: #ROWS
      UnitOfMeasure
}
