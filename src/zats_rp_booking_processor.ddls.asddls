@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Processor Projection'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZATS_RP_BOOKING_PROCESSOR
  as projection on ZATS_RP_BOOKING
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _BookingStatus,
      _BookingSupp : redirected to composition child ZATS_RP_BOOKSUPPL_PROCESSOR,
      _Carrier,
      _Connection,
      _Customer,
      _Travel      : redirected to parent ZATS_RP_TRAVEL_PROCESSOR
}
