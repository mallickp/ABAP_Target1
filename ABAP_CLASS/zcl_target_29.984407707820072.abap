CLASS zcl_cnv_2010c DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_domain_fixed_val
      IMPORTING
        !iv_domname TYPE domname
      EXPORTING
        !ev_domname TYPE domname
      TABLES
        et_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value
      RAISING
        cx_sy_dynamic_osql_error
        cx_sy_open_sql_db.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS fill_bapiret2
      IMPORTING
        !type TYPE symsgty OPTIONAL
        !cl   TYPE symsgid OPTIONAL
        !number TYPE symsgno OPTIONAL
      EXPORTING
        !return STRUCTURE bapiret2 OPTIONAL.

ENDCLASS.

CLASS zcl_cnv_2010c IMPLEMENTATION.

  METHOD get_domain_fixed_val.
    DATA: ls_bapi_ret TYPE bapiret2.

    IF iv_domname IS INITIAL.
      fill_bapiret2(
        EXPORTING
          type   = 'E'
          cl     = 'CNV_2010C'
          number = '000'
        IMPORTING
          return = ls_bapi_ret
      ).

      ls_bapi_ret-message = text-012.

      APPEND ls_bapi_ret TO et_domain_fixed_val.
      RETURN.
    ENDIF.

    SELECT ddlanguage valpos domvalue_l ddtext
      FROM dd07t
      INTO CORRESPONDING FIELDS OF TABLE @et_domain_fixed_val
      WHERE domname = @iv_domname
      AND ddlanguage = @sy-langu
      AND as4local = 'A'.

    IF sy-subrc = 0.
      SORT et_domain_fixed_val BY valpos.
      ev_domname = iv_domname.
    ELSE.
      SELECT ddlanguage valpos domvalue_l ddtext
        FROM dd07t
        INTO CORRESPONDING FIELDS OF TABLE @et_domain_fixed_val
        WHERE domname = @iv_domname
        AND ddlanguage = 'E'
        AND as4local = 'A'.
      IF sy-subrc = 0.
        SORT et_domain_fixed_val BY valpos.
        ev_domname = iv_domname.
      ELSE.
        fill_bapiret2(
          EXPORTING
            type   = 'E'
            cl     = 'CNV_2010C'
            number = '000'
          IMPORTING
            return = ls_bapi_ret
        ).

        ls_bapi_ret-message = text-013.

        APPEND ls_bapi_ret TO et_domain_fixed_val.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD fill_bapiret2.
    return-type = type.
    return-id = cl.
    return-number = number.
    return-message_v1 = cl.
    return-message_v2 = number.
  ENDMETHOD.

ENDCLASS.