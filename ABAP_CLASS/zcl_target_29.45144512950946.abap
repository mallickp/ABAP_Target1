Here is the optimized ABAP code using ABAP 7.40 syntax:

```abap
CLASS zcl_cnv_2010c DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS cnv_2010c_fill_bapi_ret2
      IMPORTING
        !type       TYPE bapireturn-type
        !cl         TYPE sy-msgid
        !number     TYPE sy-msgno
        !par1       TYPE sy-msgv1 DEFAULT space
        !par2       TYPE sy-msgv2 DEFAULT space
        !par3       TYPE sy-msgv3 DEFAULT space
        !par4       TYPE sy-msgv4 DEFAULT space
        !log_no     TYPE bapireturn-log_no DEFAULT space
        !log_msg_no TYPE bapireturn-log_msg_no DEFAULT space
        !parameter  TYPE bapiret2-parameter DEFAULT space
        !row        TYPE bapiret2-row DEFAULT 0
        !field      TYPE bapiret2-field DEFAULT space
      EXPORTING
        !return     TYPE bapiret2.

    CLASS-METHODS cnv_2010c_get_domain_fixed_val
      IMPORTING
        !iv_domname TYPE domname
      EXPORTING
        !ev_domname TYPE domname
      TABLES
        et_domain_fixed_val TYPE STANDARD TABLE OF cnv_2010c_t_domain_fixed_value OPTIONAL
        return              TYPE STANDARD TABLE OF bapiret2 OPTIONAL.

ENDCLASS.

CLASS zcl_cnv_2010c IMPLEMENTATION.

  METHOD cnv_2010c_fill_bapi_ret2.
    CLEAR return.

    return = VALUE #( type = type
                      id = cl
                      number = number
                      message_v1 = par1
                      message_v2 = par2
                      message_v3 = par3
                      message_v4 = par4
                      parameter = parameter
                      row = row
                      field = field
                      system = cl_abap_system_utilities=>get_logical_system( )
                      message = |{ type }{ cl }{ number }{ par1 }{ par2 }{ par3 }{ par4 }|
                      log_no = log_no
                      log_msg_no = log_msg_no ).

  ENDMETHOD.

  METHOD cnv_2010c_get_domain_fixed_val.
    DATA: ls_bapi_ret TYPE bapiret2.

    IF iv_domname IS INITIAL.
      cnv_2010c_fill_bapi_ret2( EXPORTING type = 'E' cl = 'CNV_2010C' number = '000'
                                IMPORTING return = ls_bapi_ret ).
      ls_bapi_ret-message = 'Domname is empty'.
      APPEND ls_bapi_ret TO return.
      RETURN.
    ENDIF.

    SELECT dlanguage valpos domvalue_l ddtext
      INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
      FROM dd07t
      WHERE domname = iv_domname AND
            dlanguage = sy-langu AND
            as4local = 'A'.
    IF sy-subrc = 0.
      SORT et_domain_fixed_val BY valpos.
      ev_domname = iv_domname.
    ELSE.
      SELECT dlanguage valpos domvalue_l ddtext
        INTO CORRESPONDING FIELDS OF TABLE et_domain_fixed_val
        FROM dd07t
        WHERE domname = iv_domname AND
              dlanguage = 'E' AND
              as4local = 'A'.
      IF sy-subrc = 0.
        SORT et_domain_fixed_val BY valpos.
        ev_domname = iv_domname.
      ELSE.
        cnv_2010c_fill_bapi_ret2( EXPORTING type = 'E' cl = 'CNV_2010C' number = '000'
                                  IMPORTING return = ls_bapi_ret ).
        ls_bapi_ret-message = 'Error retrieving domain fixed values'.
        APPEND ls_bapi_ret TO return.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
```

This code creates a new ABAP class called `zcl_cnv_2010c` and converts the original function modules to class methods. Additionally, it uses inline declarations and string templates for better readability and code optimization.