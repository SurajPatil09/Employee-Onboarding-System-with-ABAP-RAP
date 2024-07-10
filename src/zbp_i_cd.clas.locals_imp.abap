CLASS lhc_zi_cd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
CONSTANTS:

      BEGIN OF Candidate_status,
        open     TYPE c LENGTH 10  VALUE 'Open', " Open
        accepted TYPE c LENGTH 10  VALUE 'Onboarded', " Accepted
        canceled TYPE c LENGTH 10  VALUE 'Cancelled', " Cancelled
      END OF Candidate_status.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR candidate RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR candidate RESULT result.

    METHODS Accept_Candidate FOR MODIFY
      IMPORTING keys FOR ACTION candidate~Accept_Candidate RESULT result.

    METHODS Reject_Candidate FOR MODIFY
      IMPORTING keys FOR ACTION candidate~Reject_Candidate RESULT result.

    METHODS setinitialstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR candidate~setinitialstatus.

    METHODS createcandidateid FOR DETERMINE ON SAVE
      IMPORTING keys FOR candidate~createcandidateid.

    METHODS validatename FOR VALIDATE ON SAVE
      IMPORTING keys FOR candidate~validatename.

    METHODS validatelname FOR VALIDATE ON SAVE
      IMPORTING keys FOR candidate~validatelname.
    METHODS validatecurrency FOR VALIDATE ON SAVE
      IMPORTING keys FOR candidate~validatecurrency.

ENDCLASS.

CLASS lhc_zi_cd IMPLEMENTATION.

METHOD setInitialStatus.
    " Reads candidate entity data from a local context (zi_cd).
    "It fetches the CandidateStatus field for entities identified by given keys.
    READ ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
        FIELDS ( CandidateStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(candidates).

    " Remove all candidate instance data with defined status
    DELETE candidates WHERE CandidateStatus IS NOT INITIAL.
    CHECK candidates IS NOT INITIAL.

    " Set default candidate status
    MODIFY ENTITIES OF zi_cd IN LOCAL MODE
    ENTITY candidate
      UPDATE
        FIELDS ( CandidateStatus )
        WITH VALUE #( FOR candidate IN candidates
                      ( %tky         = candidate-%tky
                        CandidateStatus = candidate_status-open ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD CreateCandidateID.

*      " check if Emp_Id is already filled
*    READ ENTITIES OF zi_cd IN LOCAL MODE
*      ENTITY candidate
*        FIELDS ( CanId ) WITH CORRESPONDING #( keys )
*      RESULT DATA(candidates). "here define work area as candidates and result stored in it.
*
*    " remove lines where Emp_Id is already filled.
*    DELETE candidates WHERE CanId IS NOT INITIAL.
*
*
*    " anything left ?
*    CHECK candidates IS NOT INITIAL.
*
*
*    " Select max candidate ID
*    SELECT SINGLE
*        FROM  zdt_cd_431
*        FIELDS MAX( can_id ) AS CanId
*        INTO @DATA(max_CanId).
*
*    " Set the candidate ID
*    MODIFY ENTITIES OF zi_cd IN LOCAL MODE
*    ENTITY candidate
*      UPDATE
*        FROM VALUE #( FOR candidate IN candidates INDEX INTO i (
*          %tky              = candidate-%tky
*          CanId          = max_CanId + i
*         %control-CanId = if_abap_behv=>mk-on ) )
*    REPORTED DATA(update_reported).
*
*    reported = CORRESPONDING #( DEEP update_reported ).
******************************************************************************
********************************************************************************
*data declaration:
    DATA:
      lt_candidates TYPE TABLE OF zdt_cd_431,
      lt_update_candidates TYPE TABLE OF zdt_cd_431,
      lv_max_canid TYPE zdt_cd_431-can_id,
      lv_index TYPE i.

*    " Fetch candidates where CanId is initial and keys match
*    SELECT FROM candidate
*      FIELDS ( CanId )
*      INTO TABLE @lt_candidates
*      fields IN @keys
*      WHERE CanId IS INITIAL
*        AND CanId = @keys-CanId.
*
*    " Check if candidates were fetched
*    IF lt_candidates IS NOT INITIAL.

    READ ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
        FIELDS ( CanId ) WITH CORRESPONDING #( keys )
      RESULT DATA(candidates). "here define work area as candidates and result stored in it.

    " remove lines where Emp_Id is already filled.
    DELETE candidates WHERE CanId IS NOT INITIAL.

*      " Select max candidate ID
*      SELECT SINGLE MAX( CanId ) INTO @lv_max_canid FROM candidate.

          SELECT SINGLE
        FROM  zdt_cd_431
        FIELDS MAX( can_id ) AS CanId
        INTO @lv_max_canid.

      " Update candidates with generated CanIds
      LOOP AT lt_candidates ASSIGNING FIELD-SYMBOL(<ls_candidate>).
        lv_index = lv_index + 1.
        <ls_candidate>-Can_Id = lv_max_canid + lv_index.
        APPEND <ls_candidate> TO lt_update_candidates.
      ENDLOOP.


      MODIFY ENTITIES OF zi_cd IN LOCAL MODE
    ENTITY candidate
      UPDATE FIELDS ( CanId )
        WITH VALUE #( FOR entity IN keys INDEX INTO i (
        %tky          = entity-%tky
        CanId     = lv_max_canid + i
  ) ).


 ENDMETHOD.
**************************************************************************************
 METHOD validateName.

*READ ENTITIES OF zi_cd IN LOCAL MODE
*    ENTITY candidate
*    FIELDS ( FirstName ) WITH CORRESPONDING #( keys )
*    RESULT DATA(preferss).
*
*DATA: lt_existing_first_names TYPE TABLE OF zdt_cd_431-first_name.
*
*SELECT first_name FROM zdt_cd_431 INTO TABLE @lt_existing_first_names.
*
*LOOP AT preferss INTO DATA(candidate).
*    IF candidate-FirstName IN lt_existing_first_names.
*        " Candidate with same FirstName exists in zi_cd table
*        APPEND VALUE #( FirstName = candidate-FirstName
*                        Message = 'Candidate First Name is already present' )
*              TO reported_candidates.
*    ELSE.
*        " Candidate with FirstName does not exist in zi_cd table
*        APPEND VALUE #( FirstName = candidate-FirstName )
*              TO valid_candidates.
*    ENDIF.
*ENDLOOP.
*

  READ ENTITIES OF zi_cd IN LOCAL MODE
    ENTITY candidate
    FIELDS ( FirstName ) WITH CORRESPONDING #( keys )
    RESULT DATA(preferss).

  LOOP AT preferss INTO DATA(candidate).
    SELECT SINGLE * FROM zi_cd
        WHERE FirstName = @candidate-FirstName
        INTO @DATA(ls_FirstName).
    IF sy-subrc = 0.
      APPEND VALUE #( %tky = candidate-%tky ) TO failed-candidate.
      APPEND VALUE #( %tky = candidate-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                    text = 'Candidate First Name is already present' )
                     ) TO reported-candidate.
    ENDIF.
  ENDLOOP.
  ENDMETHOD.

**************************************************************************************
  METHOD validateLName.
  READ ENTITIES OF zi_cd IN LOCAL MODE
    ENTITY candidate
    FIELDS ( LastName ) WITH CORRESPONDING #( keys )
    RESULT DATA(preferss).

  LOOP AT preferss INTO DATA(candidate).
    SELECT SINGLE * FROM zi_cd
        WHERE LastName = @candidate-LastName
        INTO @DATA(ls_LastName).
    IF sy-subrc = 0.
      APPEND VALUE #( %tky = candidate-%tky ) TO failed-candidate.
      APPEND VALUE #( %tky = candidate-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                    text = 'Candidate Last Name is already present' )
                     ) TO reported-candidate.
    ENDIF.
  ENDLOOP.
  ENDMETHOD.
**************************************************************************************
    METHOD get_instance_authorizations.
  ENDMETHOD.
**************************************************************************************
  METHOD get_instance_features.
  " Read the candidate status of the existing candidates
     READ ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
        FIELDS ( CandidateStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(candidates)
      FAILED failed.

    result =
      VALUE #(
        FOR candidate IN candidates
          LET is_accepted =   COND #( WHEN candidate-CandidateStatus = Candidate_status-accepted
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN candidate-CandidateStatus = Candidate_status-canceled
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = candidate-%tky
              %action-Accept_Candidate = is_accepted
              %action-Reject_Candidate = is_rejected
             ) ).

  ENDMETHOD.
**************************************************************************************
  METHOD Accept_Candidate.
     " Set the new overall status
    MODIFY ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
         UPDATE
           FIELDS ( CandidateStatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             CandidateStatus = candidate_status-accepted ) )
      FAILED failed
      REPORTED reported.
    " Fill the response table
    READ ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(candidates).

    result = VALUE #( FOR candidate IN candidates
                        ( %tky   = candidate-%tky
                          %param = candidate ) ).
  ENDMETHOD.
**************************************************************************************
  METHOD Reject_Candidate.
    " Set the new overall status
    MODIFY ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
         UPDATE
           FIELDS ( CandidateStatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             CandidateStatus = candidate_status-canceled ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_cd IN LOCAL MODE
      ENTITY candidate
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(candidates).

    result = VALUE #( FOR candidate IN candidates
                        ( %tky   = candidate-%tky
                          %param = candidate ) ).
  ENDMETHOD.
**************************************************************************************



  METHOD validatecurrency.
      READ ENTITIES OF zi_cd IN LOCAL MODE
        ENTITY candidate
        FIELDS ( currencycode ) WITH CORRESPONDING #( keys )
        RESULT DATA(carriers).

    LOOP AT carriers INTO DATA(candidate).
      SELECT SINGLE * FROM i_currency
          WHERE currency = @candidate-currencycode
          INTO @DATA(ls_currrency).
      IF sy-subrc NE 0.
        APPEND VALUE #( %tky = candidate-%tky ) TO failed-candidate.
        APPEND VALUE #( %tky = candidate-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Currency Code is not valid' )
                       ) TO reported-candidate.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

******************************************************************************************

ENDCLASS.
