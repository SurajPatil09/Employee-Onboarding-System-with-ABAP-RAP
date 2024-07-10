@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Y/N Value Help'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define root view entity  ZI_VH_YN as select from zvh_yn
{
    key srno as Srno,
    valuehelp as Valuehelp
}
