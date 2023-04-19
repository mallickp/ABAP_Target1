CLASS zcl_cnv_2010c_fill_bapiret2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    TYPES: BEGIN OF ty_bapiret2_structure,
            type LIKE bapireturn-type,
            cl LIKE sy-msgid,
            number LIKE sy-msgno,
            par1 LIKE sy-msgv1,
            par2 LIKE sy-msgv2,
            par3 LIKE sy-msgv3,
            par4 LIKE sy-msgv4,
            log_no LIKE bapireturn-log_no,
            log_msg_no LIKE bapireturn-log_msg_no,
            parameter LIKE bapiret2-parameter,
            row LIKE bapiret2-row,
            field LIKE bapiret2-field,
           END OF ty_bapiret2_structure.

    METHODS fill_bapiret2
      IMPORTING
        !is_input_data    TYPE ty_bapiret2_structure
      EXPORTING
        !es_return        TYPE bapiret2.

    METHODS get_domain_fixed_val
      IMPORTING
        !iv_domname       TYPE domname
      EXPORTING
        !ev_domname       TYPE domname
      TABLES
        !et_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value
      RAISING
        cx_sy_error_messages.
ENDCLASS.

CLASS zcl_cnv_2010c_fill_bapiret2 IMPLEMENTATION.

  METHOD fill_bapiret2.
    es_return-type = is_input_data-type.
    es_return-id = is_input_data-cl.
    es_return-number = is_input_data-number.
    es_return-message_v1 = is_input_data-par1.
    es_return-message_v2 = is_input_data-par2.
    es_return-message_v3 = is_input_data-par3.
    es_return-message_v4 = is_input_data-par4.
    es_return-log_no = is_input_data-log_no.
    es_return-log_msg_no = is_input_data-log_msg_no.
    es_return-parameter = is_input_data-parameter.
    es_return-row = is_input_data-row.
    es_return-field = is_input_data-field.
  ENDMETHOD.

  METHOD get_domain_fixed_val.
    CALL FUNCTION 'CNV_2010C_GET_DOMAIN_FIXED_VAL'
      EXPORTING
        iv_domname          = iv_domname
      IMPORTING
        ev_domname          = ev_domname
      TABLES
        et_domain_fixed_val = et_domain_fixed_val
      EXCEPTIONS
        OTHERS              = 1.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_sy_error_messages.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
