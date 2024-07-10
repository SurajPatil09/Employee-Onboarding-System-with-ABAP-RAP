@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Proj view'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_EMPL_431 as projection on zi_empl_431
{
    key EmpUuid as EmpUuid,
    key CanUuid as CanUuid,
    EmpId as EmpId ,
    @Search.defaultSearchElement: true
    CanId as CanId,
    Dateofjoining as Dateofjoining,
    ProjName as ProjectName,
    ProjAssignStartdate as ProjAssignStartDate,
    ProjAssignEnddate as ProjAssignEndDate,
    Location as Location,
    Promotionstatus as Promotionstatus,
    LocalLastChangedAt as LocalLastChangedAt,
    
     /* Associations */
    _can: redirected to parent ZC_CD,
    _hr : redirected to composition child ZC_HR_431
} 
  
