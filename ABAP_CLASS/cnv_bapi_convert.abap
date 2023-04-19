Below is the optimized source code using ABAP 7.40 syntax and features like inline declarations and string templates:

```ABAP

CLASS zcl_cnv_2010c DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS fill_bapiret2
      IMPORTING
        VALUE(iv_type) LIKE BAPIRETURN-TYPE
        VALUE(iv_cl) LIKE SY-MSGID
        VALUE(iv_number) LIKE SY-MSGNO
        VALUE(iv_par1) LIKE SY-MSGV1 DEFAULT SPACE
        VALUE(iv_par2) LIKE SY-MSGV2 DEFAULT SPACE
        VALUE(iv_par3) LIKE SY-MSGV3 DEFAULT SPACE
        VALUE(iv_par4) LIKE SY-MSGV4 DEFAULT SPACE
        VALUE(iv_log_no) LIKE BAPIRETURN-LOG_NO DEFAULT SPACE
        VALUE(iv_log_msg_no) LIKE BAPIRETURN-LOG_MSG_NO DEFAULT SPACE
        VALUE(iv_parameter) LIKE BAPIRET2-PARAMETER DEFAULT SPACE
        VALUE(iv_row) LIKE BAPIRET2-ROW DEFAULT 0
        VALUE(iv_field) LIKE BAPIRET2-FIELD DEFAULT SPACE
      EXPORTING
        REFERENCE(er_return) LIKE BAPIRET2 STRUCTURE BAPIRET2.

    CLASS-METHODS get_domain_fixed_val
      IMPORTING
        VALUE(iv_domname) TYPE_DOMNAME
      EXPORTING
        VALUE(ev_domname) TYPE_DOMNAME
        et_domain_fixed_val TYPE TABLE OF zcl_cnv_2010c=>ty_domain_fixed_value OPTIONAL
        RETURN STRUCTURE BAPIRET2 OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_domain_fixed_value,
             ddlanguage TYPE ddlanguage,
             valpos TYPE valpos,
             domvalue_l TYPE domvalue_l,
             ddtext TYPE ddtext,
           END OF ty_domain_fixed_value.
ENDCLASS.



CLASS zcl_cnv_2010c IMPLEMENTATION.

  METHOD fill_bapiret2.
    CLEAR er_return.

    er_return-TYPE = iv_type.
    er_return-ID = iv_cl.
    er_return-NUMBER = iv_number.
    er_return-MESSAGE_V1 = iv_par1.
    er_return-MESSAGE_V2 = iv_par2.
    er_return-MESSAGE_V3 = iv_par3.
    er_return-MESSAGE_V4 = iv_par4.
    er_return-PARAMETER = iv_parameter.
    er_return-ROW = iv_row.
    er_return-FIELD = iv_field.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET_STABLE'
      IMPORTING
        OWN_LOGICAL_SYSTEM = er_return-SYSTEM.

    MESSAGE ID iv_cl
            TYPE iv_type
            NUMBER iv_number
            WITH iv_par1 iv_par2 iv_par3 iv_par4
            INTO er_return-MESSAGE.

    er_return-LOG_NO = iv_log_no.
    er_return-LOG_MSG_NO = iv_log_msg_no.

  ENDMETHOD.

  METHOD get_domain_fixed_val.
    DATA: ls_bapi_ret TYPE BAPIRET2.

    IF iv_domname IS INITIAL.
      fill_bapiret2(
        EXPORTING
          iv_type = 'E'
          iv_cl = 'CNV_2010C'
          iv_number = '000'
        IMPORTING
          er_return = ls_bapi_ret ).
      ls_bapi_ret-MESSAGE = 'No Domain name provided.'.
      APPEND ls_bapi_ret TO RETURN.
      RETURN.
    ENDIF.

    SELECT ddlanguage valpos domvalue_l ddtext
      INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
      FROM dd07t
      WHERE domname = iv_domname
      AND ddlanguage EQ SY-LANGU
      AND as4local EQ 'A'.

    IF SY-SUBRC EQ 0.
      SORT et_domain_fixed_val ASCENDING BY valpos.
      ev_domname = iv_domname.
    ELSE.

      SELECT ddlanguage valpos domvalue_l ddtext
        INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
        FROM dd07t
        WHERE domname = iv_domname
          AND ddlanguage EQ 'E'
          AND as4local EQ 'A'.

      IF SY-SUBRC EQ 0.
        SORT et_domain_fixed_val ASCENDING BY valpos.
        ev_domname = iv_domname.
      ELSE.

        fill_bapiret2(
          EXPORTING
            iv_type = 'E'
            iv_cl = 'CNV_2010C'
            iv_number = '000'
          IMPORTING
            er_return = ls_bapi_ret ).
        ls_bapi_ret-MESSAGE = 'No domain value found for domain name.'.
        APPEND ls_bapi_ret TO RETURN.

      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

```
