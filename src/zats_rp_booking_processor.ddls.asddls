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

      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Customer' ,
                                           entity.element: 'CustomerID'
                                           }]
      CustomerId,

      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Carrier' ,
                                           entity.element: 'AirlineID'
                                           }]
      CarrierId,

      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Connection' ,
                                           entity.element: 'ConnectionID',
                                           additionalBinding: [
                                                                { localElement: 'CarrierId',
                                                                  element: 'AirlineID' }
                                                               ]
                                           }]
      ConnectionId,

      FlightDate,
      FlightPrice,

      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Currency' ,
                                           entity.element: 'Currency'
                                           } ]
      CurrencyCode,
      
      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Booking_Status_VH' , 
                                           entity.element: 'BookingStatus' 
                                           }]
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
