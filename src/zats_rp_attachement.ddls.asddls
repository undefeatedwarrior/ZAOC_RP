@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachement CDS entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity zats_rp_attachement
  as select from zats_rp_attach as _Attachement

  -- Association to Parent
  association        to parent ZATS_RP_TRAVEL    as _Travel        on  $projection.TravelId = _Travel.TravelId


{
  key travel_id             as TravelId,
  
  @EndUserText.label: 'Attachement ID'
  key id                    as Id,
      
      @EndUserText.label: 'Comments'
      memo                  as Memo,

      @Semantics.largeObject:   {   mimeType: 'Filetype',
                                    fileName: 'Filename',
                                    contentDispositionPreference: #INLINE,
                                    acceptableMimeTypes: [ 'application/pdf' ]
                                }
      @EndUserText.label: 'Attachement'
      attachment            as Attachment,

      @EndUserText.label: 'File Name'
      filename              as Filename,

      @EndUserText.label: 'File Type'
      @Semantics.mimeType: true
      filetype              as Filetype,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,

      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,

      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      
      _Travel

}
