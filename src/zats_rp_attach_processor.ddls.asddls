@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Processor Projection'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZATS_RP_ATTACH_PROCESSOR
  as projection on zats_rp_attachement
{
  key TravelId,
  key Id,
      Memo,
      Attachment,
      Filename,
      Filetype,
      LastChangedAt,
      LocalCreatedAt,
      LocalCreatedBy,
      LocalLastChangedAt,
      LocalLastChangedBy,

      _Travel : redirected to parent ZATS_RP_TRAVEL_PROCESSOR
}
