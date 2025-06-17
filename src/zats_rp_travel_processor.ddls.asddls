@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Processor Projection'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZATS_RP_TRAVEL_PROCESSOR
  as projection on ZATS_RP_TRAVEL
{
      @ObjectModel.text.element: [ 'Description' ]
  key TravelId,

      @ObjectModel.text.element: [ 'AgencyName' ]                                     //Field Description Column name
      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Agency' ,
                                           entity.element: 'AgencyID'
                                           }]                                         //Value Help
      AgencyId,
      @Semantics.text: true
      _Agency.Name       as AgencyName,

      @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Customer' ,
                                           entity.element: 'CustomerID'
                                           }]                                         //Value Help
      CustomerId,
      @Semantics.text: true
      _Customer.LastName as CustomerName,

      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,

      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Currency' ,
                                           entity.element: 'Currency'} ]
      CurrencyCode,
      @Semantics.text: true
      Description,

      @ObjectModel.text.element: [ 'StatusText' ]
      @Consumption.valueHelpDefinition: [{ entity.name: '/DMO/I_Overall_Status_VH' ,
                                           entity.element: 'OverallStatus'
                                           }]                                         //Value Help
      overallstatus,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      @Semantics.text: true
      StatusText,
      Criticality,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZATS_RP_BOOKING_PROCESSOR,
      _Currency,
      _Customer,
      _OverallStatus
}
