@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR View'
@Metadata.ignorePropagatedAnnotations: true

//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}

define view entity zi_hr_431 as select from zdt_hr_431

association to parent zi_empl_431 as _emp  on $projection.CanUuid = _emp.CanUuid
                                           and $projection.EmpUuid = _emp.EmpUuid
association [1..1] to zi_cd      as _can   on $projection.CanUuid = _can.CanUuid
{
    key hr_uuid as HrUuid,
    key emp_uuid as EmpUuid,
    key can_uuid as CanUuid,
    lastdesignation as Lastdesignation,
    experience as Experience,
        @Consumption.valueHelpDefinition: [{
      entity: {
          name: 'zi_empl_431',
          element: 'Promotionstatus'
      }}]
    seperation as Seperation,
    seperationdate as Seperationdate,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat,
    
    _emp,
    _can
//    _value
}
