Here is the optimized source code using ABAP 7.40 syntax and features:

```abap
CLASS lcl_message_helper DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: cnv_2010c_fill_bapiret2
      IMPORTING
        !type      LIKE bapireturn-type
        !cl        LIKE sy-msgid
        !number    LIKE sy-msgno
        !par1      LIKE sy-msgv1 DEFAULT SPACE
        !par2      LIKE sy-msgv2 DEFAULT SPACE
        !par3      LIKE sy-msgv3 DEFAULT SPACE
        !par4      LIKE sy-msgv4 DEFAULT SPACE
        !log_no    LIKE bapireturn-log_no DEFAULT SPACE
        !log_msg_no LIKE bapireturn-log_msg_no DEFAULT SPACE
        !parameter LIKE bapiret2-parameter DEFAULT SPACE
        !row       LIKE bapiret2-row DEFAULT 0
        !field     LIKE bapiret2-field DEFAULT SPACE
      RETURNING
        VALUE(r_bapiret2) TYPE bapiret2.
ENDCLASS.

CLASS lcl_message_helper IMPLEMENTATION.
  METHOD cnv_2010c_fill_bapiret2.
    DATA: lv_own_logical_system TYPE sy-lisel.

    r_bapiret2 = VALUE #( type = type id = cl number = number
                          message_v1 = par1 message_v2 = par2
                          message_v3 = par3 message_v4 = par4
                          parameter = parameter row = row field = field ).

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET_STABLE'
      IMPORTING
        own_logical_system = lv_own_logical_system.

    r_bapiret2-system = lv_own_logical_system.

    MESSAGE ID cl TYPE type NUMBER number WITH par1 par2 par3 par4
              INTO r_bapiret2-message.
    r_bapiret2-log_no = log_no.
    r_bapiret2-log_msg_no = log_msg_no.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_domain_value_helper DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: cnv_2010c_get_domain_fixed_val
      IMPORTING
        !iv_domname  TYPE domname
      EXPORTING
        !ev_domname  TYPE domname
      CHANGING
        !ct_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value
        !ct_return           TYPE bapiret2.
ENDCLASS.

CLASS lcl_domain_value_helper IMPLEMENTATION.
  METHOD cnv_2010c_get_domain_fixed_val.
    DATA(ls_bapi_ret) = lcl_message_helper=>cnv_2010c_fill_bapiret2( type = 'E' cl = 'CNV_2010C' number = '000' ).

    IF iv_domname IS INITIAL.
      ls_bapi_ret-message = 'Domain name is missing'(012).
      APPEND ls_bapi_ret TO ct_return.
      RETURN.
    ENDIF.

    SELECT ddlanguage valpos domvalue_l ddtext
      FROM dd07t
      INTO CORRESPONDING FIELDS OF TABLE ct_domain_fixed_val
      WHERE domname = iv_domname AND ddlanguage EQ sy-langu AND as4local EQ 'A'.

    IF sy-subrc = 0.
      SORT ct_domain_fixed_val ASCENDING BY valpos.
      ev_domname = iv_domname.
    ELSE.
      SELECT ddlanguage valpos domvalue_l ddtext
        FROM dd07t
        INTO CORRESPONDING FIELDS OF TABLE ct_domain_fixed_val
        WHERE domname = iv_domname AND ddlanguage EQ 'E' AND as4local EQ 'A'.

      IF sy-subrc = 0.
        SORT ct_domain_fixed_val ASCENDING BY valpos.
        ev_domname = iv_domname.
      ELSE.
        ls_bapi_ret = lcl_message_helper=>cnv_2010c_fill_bapiret2( type = 'E' cl = 'CNV_2010C' number = '000' ).
        ls_bapi_ret-message = 'Domain value not found'(013).
        APPEND ls_bapi_ret TO ct_return.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
```