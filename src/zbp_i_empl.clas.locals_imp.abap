CLASS lhc_employee DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR employee RESULT result.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR employee RESULT result.

*    METHODS acceptPromotion FOR MODIFY
*      IMPORTING keys FOR ACTION employee~acceptPromotion RESULT result.
*
*    METHODS rejectPromotion FOR MODIFY
*      IMPORTING keys FOR ACTION employee~rejectPromotion RESULT result.

*    METHODS setInitialPromotionStatus FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR employee~setInitialPromotionStatus.

    METHODS CreateEmployeeID FOR DETERMINE ON SAVE
      IMPORTING keys FOR employee~CreateEmployeeID.

ENDCLASS.

CLASS lhc_employee IMPLEMENTATION.

*  METHOD get_instance_features.
*  ENDMETHOD.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

*  METHOD acceptPromotion.
*  ENDMETHOD.
*
*  METHOD rejectPromotion.
*  ENDMETHOD.

*  METHOD setInitialPromotionStatus.
*  ENDMETHOD.

METHOD CreateEmployeeID.

DATA update TYPE TABLE FOR UPDATE ZI_CD\\employee.
" Read all candidates for the requested Employees.
" If multiple Employees of the same candidate are requested, the candidate is returned only once.
READ ENTITIES OF ZI_CD IN LOCAL MODE
  ENTITY employee BY \_can
    FIELDS ( CanId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(candidates).

" Process all affected candidates. Read respective Employees, generate employee ID and update the Employees without ID.
LOOP AT candidates INTO DATA(candidate).
  DATA(candidate_id) = candidate-CanId.

  READ ENTITIES OF ZI_CD IN LOCAL MODE
    ENTITY candidate BY \_emp
      FIELDS ( EmpId )
    WITH VALUE #( ( %tky = candidate-%tky ) )
    RESULT DATA(Employees).

  " Provide a Employee ID for all Employees that have none.
  LOOP AT Employees INTO DATA(employee) WHERE EmpId IS INITIAL.
    DATA(employee_id) = |{ candidate_id }|.
    APPEND VALUE #( %tky      = employee-%tky
                    EmpId = employee_id
                  ) TO update.
  ENDLOOP.
ENDLOOP.

" Update the Employee ID of all relevant Employees
MODIFY ENTITIES OF ZI_CD IN LOCAL MODE
  ENTITY employee
    UPDATE FIELDS ( EmpId ) WITH update
  REPORTED DATA(update_reported).

reported = CORRESPONDING #( DEEP update_reported ).
ENDMETHOD.

ENDCLASS.
