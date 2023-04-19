Here is the optimized source code using ABAP 7.40 syntax and features, like inline declarations and string templates, for the given function modules:

```abap
CLASS zcl_cnv_2010c DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS fill_bapiret2
      IMPORTING
        !type        TYPE bapiret2-type
        !cl          TYPE sy-msgid
        !number      TYPE sy-msgno
        !par1        TYPE sy-msgv1 DEFAULT abap_space
        !par2        TYPE sy-msgv2 DEFAULT abap_space
        !par3        TYPE sy-msgv3 DEFAULT abap_space
        !par4        TYPE sy-msgv4 DEFAULT abap_space
        !log_no      TYPE bapiret2-log_no DEFAULT abap_space
        !log_msg_no  TYPE bapiret2-log_msg_no DEFAULT abap_space
        !parameter   TYPE bapiret2-parameter DEFAULT abap_space
        !row         TYPE bapiret2-row DEFAULT 0
        !field       TYPE bapiret2-field DEFAULT abap_space
      RETURNING
        VALUE(bapiret2) TYPE bapiret2.

    CLASS-METHODS get_domain_fixed_val
      IMPORTING
        !iv_domname  TYPE dd07l-domname
      RETURNING
        VALUE(ev_domname)  TYPE dd07l-domname
      EXPORTING
        et_domain_fixed_val TYPE STANDARD TABLE OF dd07t
        return              TYPE bapiret2 OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_cnv_2010c IMPLEMENTATION.
  METHOD fill_bapiret2.
    bapiret2 = VALUE #( TYPE = !type
                        ID = !cl
                        NUMBER = !number
                        MESSAGE_V1 = !par1
                        MESSAGE_V2 = !par2
                        MESSAGE_V3 = !par3
                        MESSAGE_V4 = !par4
                        PARAMETER = !parameter
                        ROW = !row
                        FIELD = !field
                        LOG_NO = !log_no
                        LOG_MSG_NO = !log_msg_no
                        SYSTEM = cl_system_helper=>get_own_logical_system_stable( )
                        MESSAGE = || ).

    IF !type EQ 'A' OR !type EQ 'E' OR !type EQ 'I' OR !type EQ 'W' OR !type EQ 'S' OR !type EQ 'X'.
      MESSAGE ID !cl TYPE !type NUMBER !number
        WITH !par1 !par2 !par3 !par4
        INTO bapiret2-message.
    ENDIF.
  ENDMETHOD.

  METHOD get_domain_fixed_val.
    DATA: ls_bapi_ret TYPE bapiret2.

    IF iv_domname IS INITIAL.
      zcl_cnv_2010c=>fill_bapiret2(
        EXPORTING
          type   = 'E'
          cl     = 'CNV_2010C'
          number = '000'
        RETURNING
          bapiret2 = ls_bapi_ret ).
      ls_bapi_ret-message = 'Invalid Domain Name provided'.
      APPEND ls_bapi_ret TO return.
      RETURN.
    ENDIF.

    SELECT ddlanguage valpos domvalue_l ddtext
      FROM dd07t
      INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
      WHERE domname = iv_domname
        AND ddlanguage = sy-langu
        AND as4local = 'A'.

    IF sy-subrc = 0.
      SORT et_domain_fixed_val BY valpos.
      ev_domname = iv_domname.
    ELSE.
      SELECT ddlanguage valpos domvalue_l ddtext
        FROM dd07t
        INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
        WHERE domname = iv_domname
          AND ddlanguage = 'E'
          AND as4local = 'A'.

      IF sy-subrc = 0.
        SORT et_domain_fixed_val BY valpos.
        ev_domname = iv_domname.
      ELSE.
        zcl_cnv_2010c=>fill_bapiret2(
          EXPORTING
            type   = 'E'
            cl     = 'CNV_2010C'
            number = '000'
          RETURNING
            bapiret2 = ls_bapi_ret ).
        ls_bapi_ret-message = 'Domain Name not found'.
        APPEND ls_bapi_ret TO return.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
```