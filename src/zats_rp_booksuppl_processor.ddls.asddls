@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement Processor Projection'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZATS_RP_BOOKSUPPL_PROCESSOR
  as projection on ZATS_RP_BOOKSUPPL
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,

      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Supplement' ,
                                           entity.element: 'SupplementID'
                                           }]
      SupplementId,

      Price,

      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Currency' ,
                                           entity.element: 'Currency'
                                           }]
      CurrencyCode,

      LastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZATS_RP_BOOKING_PROCESSOR,
      _Product,
      _SupplementText,
      _Travel  : redirected to ZATS_RP_TRAVEL_PROCESSOR
}
