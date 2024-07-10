@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Proj View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_HR_431 as projection on zi_hr_431
{
    key HrUuid as HrUuid,
    key EmpUuid as EmpUuid ,
    key CanUuid as CanUuid ,
    Lastdesignation as LastDesignation,   
    Experience as Experience,    
    Seperation as Seperation,   
    Seperationdate as SeperationDate,
    Lastchangedat as Lastchangedat,
    

        /* Associations */
    _emp : redirected to parent ZC_EMPL_431,
    _can: redirected to ZC_CD
}
