@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Employee view'

//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}

define view entity zi_empl_431 as select from zdt_emp_431
association to parent zi_cd as _can on $projection.CanUuid = _can.CanUuid
composition [0..*] of zi_hr_431 as _hr
//association [0..1] to ZI_VH_YN      as _value on $projection.Srno = _value.Srno
{
    key emp_uuid as EmpUuid,
    key can_uuid as CanUuid,
    emp_id as EmpId,
    can_id as CanId,
    dateofjoining as Dateofjoining,
    proj_name as ProjName,
    proj_assign_startdate as ProjAssignStartdate,
    proj_assign_enddate as ProjAssignEnddate,
    location as Location,
//    @Consumption.valueHelpDefinition: [{
//      entity: {
//          name: 'zi_empl_431',
//          element: 'Promotionstatus'
//      }}]
    promotionstatus as Promotionstatus,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    
    _can,
    _hr
//    _Value
}
