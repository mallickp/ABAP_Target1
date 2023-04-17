Here is the optimized ABAP 7.40 code with inline declarations and string templates:

CLASS lcl_message_util DEFINITION.
  PUBLIC SECTION.
    METHODS:
      fill_bapiret2
        IMPORTING
          !iv_type          LIKE sy-msgty
          !iv_cl            LIKE sy-msgid
          !iv_number        LIKE sy-msgno
          !iv_par1          LIKE sy-msgv1 DEFAULT space
          !iv_par2          LIKE sy-msgv2 DEFAULT space
          !iv_par3          LIKE sy-msgv3 DEFAULT space
          !iv_par4          LIKE sy-msgv4 DEFAULT space
          !iv_log_no        LIKE bapireturn-log_no DEFAULT space
          !iv_log_msg_no    LIKE bapireturn-log_msg_no DEFAULT space
          !iv_parameter     LIKE bapiret2-parameter DEFAULT space
          !iv_row           LIKE bapiret2-row DEFAULT 0
          !iv_field         LIKE bapiret2-field DEFAULT space
        RETURNING
          VALUE(rs_bapiret) TYPE bapiret2.
ENDCLASS.

CLASS lcl_message_util IMPLEMENTATION.
  METHOD fill_bapiret2.
    DATA: lv_message TYPE string.
    rs_bapiret = VALUE #( type         = iv_type
                           id           = iv_cl
                           number       = iv_number
                           message_v1   = iv_par1
                           message_v2   = iv_par2
                           message_v3   = iv_par3
                           message_v4   = iv_par4
                           parameter    = iv_parameter
                           row          = iv_row
                           field        = iv_field
                           log_no       = iv_log_no
                           log_msg_no   = iv_log_msg_no ).

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET_STABLE'
      IMPORTING
        own_logical_system = rs_bapiret-system.

    MESSAGE ID iv_cl TYPE iv_type NUMBER iv_number
        WITH iv_par1 iv_par2 iv_par3 iv_par4
        INTO lv_message.

    rs_bapiret-message = lv_message.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_domain_value_helper DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_domain_fixed_val
        IMPORTING
          !iv_domname       TYPE domname
        EXPORTING
          !ev_domname       TYPE domname
        CHANGING
          !ct_domain_fixed_val TYPE STANDARD TABLE
          !ct_bapiret          TYPE STANDARD TABLE
        RAISING
          cx_sy_message.
ENDCLASS.

CLASS lcl_domain_value_helper IMPLEMENTATION.
  METHOD get_domain_fixed_val.
    DATA: ls_bapi_ret TYPE bapiret2.

    IF iv_domname IS INITIAL.
      ls_bapi_ret = lcl_message_util=>fill_bapiret2( iv_type    = 'E'
                                                     iv_cl      = 'CNV_2010C'
                                                     iv_number  = '000' ).
      ls_bapi_ret-message = 'Please enter domain name.'.
      INSERT ls_bapi_ret INTO TABLE ct_bapiret.
      RETURN.
    ENDIF.

    SELECT ddlanguage valpos domvalue_l ddtext
      INTO TABLE ct_domain_fixed_val
      FROM dd07t
      WHERE domname   = iv_domname
        AND ddlanguage = sy-langu
        AND as4local   = 'A'.

    IF sy-subrc = 0.
      SORT ct_domain_fixed_val BY valpos.
      ev_domname = iv_domname.
    ELSE.
      SELECT ddlanguage valpos domvalue_l ddtext
        INTO TABLE ct_domain_fixed_val
        FROM dd07t
        WHERE domname   = iv_domname
          AND ddlanguage = 'E'
          AND as4local   = 'A'.

      IF sy-subrc = 0.
        SORT ct_domain_fixed_val BY valpos.
        ev_domname = iv_domname.
      ELSE.
        ls_bapi_ret = lcl_message_util=>fill_bapiret2( iv_type    = 'E'
                                                       iv_cl      = 'CNV_2010C'
                                                       iv_number  = '000' ).
        ls_bapi_ret-message = |Domain name not found: { iv_domname }|.
        INSERT ls_bapi_ret INTO TABLE ct_bapiret.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.