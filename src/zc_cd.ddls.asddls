@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Candidate Projection view'
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_CD
    as projection on zi_cd
{
    key CanUuid as CanUuid,
    @Search.defaultSearchElement: true
    CanId as CanID,
    FirstName as FirstName ,
    LastName as LastName,
    ContactNo as ContactNo,
    InterviewDate as InterviewDate,
    CandidateStatus as CandidateStatus,
    Email as Email,
    Address as Address ,
     @Semantics.amount.currencyCode: 'CurrencyCode'
    Salary,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
    CurrencyCode,
    LocalLastChangedAt as LocalLastChangedAt,
   
    /* Associations */
    _emp: redirected to composition child ZC_EMPL_431
    
}
