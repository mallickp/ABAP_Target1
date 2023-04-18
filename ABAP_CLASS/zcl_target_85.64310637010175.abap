CLASS: zcl_converter_2010c DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS: fill_bapiret2
      IMPORTING
        !iv_type        TYPE bapireturn-type
        !iv_cl          TYPE sy-msgid
        !iv_number      TYPE sy-msgno
        !iv_par1        TYPE sy-msgv1 DEFAULT SPACE
        !iv_par2        TYPE sy-msgv2 DEFAULT SPACE
        !iv_par3        TYPE sy-msgv3 DEFAULT SPACE
        !iv_par4        TYPE sy-msgv4 DEFAULT SPACE
        !iv_log_no      TYPE bapireturn-log_no DEFAULT SPACE
        !iv_log_msg_no  TYPE bapireturn-log_msg_no DEFAULT SPACE
        !iv_parameter   TYPE bapiret2-parameter DEFAULT SPACE
        !iv_row         TYPE bapiret2-row DEFAULT 0
        !iv_field       TYPE bapiret2-field DEFAULT SPACE
      RETURNING
        VALUE(ro_bapiret2) TYPE bapiret2.

    METHODS: get_domain_fixed_val
      IMPORTING
        !iv_domname TYPE domname
      RETURNING
        VALUE(rv_domname) TYPE domname
      TABLES
        !et_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value OPTIONAL
        !et_return           TYPE bapiret2 OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_converter_2010c IMPLEMENTATION.

  METHOD fill_bapiret2.
    ro_bapiret2-type      = iv_type.
    ro_bapiret2-id        = iv_cl.
    ro_bapiret2-number    = iv_number.
    ro_bapiret2-message_v1 = iv_par1.
    ro_bapiret2-message_v2 = iv_par2.
    ro_bapiret2-message_v3 = iv_par3.
    ro_bapiret2-message_v4 = iv_par4.
    ro_bapiret2-log_no     = iv_log_no.
    ro_bapiret2-log_msg_no = iv_log_msg_no.
    ro_bapiret2-parameter  = iv_parameter.
    ro_bapiret2-row        = iv_row.
    ro_bapiret2-field      = iv_field.
  ENDMETHOD.

  METHOD get_domain_fixed_val.
    DATA: lv_domname TYPE domname,
          lt_dd07t   TYPE TABLE OF dd07t.

    rv_domname = iv_domname.

    SELECT * FROM dd07t INTO TABLE lt_dd07t
      WHERE domname = rv_domname
      AND spras = sy-langu.

    IF sy-subrc <> 0.
      SELECT * FROM dd07t INTO TABLE lt_dd07t
        WHERE domname = rv_domname
        AND spras = 'E'.
    ENDIF.

    IF lt_dd07t IS NOT INITIAL.
      et_domain_fixed_val = CORRESPONDING #( lt_dd07t ).
    ELSE.
      DATA: lr_error TYPE REF TO bapiret2.
      lr_error = fill_bapiret2( iv_type   = 'E'
                                iv_cl     = 'ZR'
                                iv_number = '000'
                                iv_par1   = iv_domname ).
      APPEND lr_error TO et_return.
    ENDIF.
  ENDMETHOD.

ENDCLASS.