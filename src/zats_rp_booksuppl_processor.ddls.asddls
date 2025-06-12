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
      SupplementId,
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZATS_RP_BOOKING_PROCESSOR,
      _Product,
      _SupplementText,
      _Travel
}
