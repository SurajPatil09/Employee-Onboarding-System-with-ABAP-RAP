CLASS zcl_vh_yn DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_vh_yn IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
DATA: lt_employee  TYPE STANDARD TABLE OF zvh_yn WITH DEFAULT KEY.

    TRY.

        lt_employee = VALUE #(
        (
        client = sy-mandt
        srno = 1
        valuehelp = 'Yes'
        )
        (
         client = sy-mandt
         srno = 2
        valuehelp = 'No'
        )




 ).


     DELETE FROM zvh_yn  .

        MODIFY zvh_yn  FROM TABLE  @lt_employee.

        out->write( |{ sy-dbcnt } entries in zvh_yn   modified| ).





        COMMIT WORK.

      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
