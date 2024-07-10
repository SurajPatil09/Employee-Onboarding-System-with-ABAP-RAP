@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Candidate view'
define root view entity zi_cd as select from zdt_cd_431
composition [0..*] of zi_empl_431 as _emp
{
    key can_uuid as CanUuid,
    can_id as CanId,
    first_name as FirstName,
    last_name as LastName,
    contact_no as ContactNo,
    interview_date as InterviewDate,
    candidate_status as CandidateStatus,
    email as Email,
    address as Address,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    salary as Salary,
    currency_code as CurrencyCode,
     @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    
    _emp // Make association public
}
