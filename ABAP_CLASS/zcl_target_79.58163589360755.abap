CLASS: ZCL_CONVERT_CNV_2010C_BAPIRET2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: fill_bapiret2
      IMPORTING
        !iv_type TYPE bapireturn-type
        !iv_cl TYPE sy-msgid
        !iv_number TYPE sy-msgno
        !iv_par1 TYPE sy-msgv1 OPTIONAL
        !iv_par2 TYPE sy-msgv2 OPTIONAL
        !iv_par3 TYPE sy-msgv3 OPTIONAL
        !iv_par4 TYPE sy-msgv4 OPTIONAL
        !iv_log_no TYPE bapireturn-log_no OPTIONAL
        !iv_log_msg_no TYPE bapireturn-log_msg_no OPTIONAL
        !iv_parameter TYPE bapiret2-parameter OPTIONAL
        !iv_row TYPE bapiret2-row OPTIONAL
        !iv_field TYPE bapiret2-field OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS ZCL_CONVERT_CNV_2010C_BAPIRET2 IMPLEMENTATION.

  METHOD fill_bapiret2.
    DATA: lv_logical_system TYPE sy-sysid.

    " 3.1 Clear the RETURN structure
    CLEAR et_return.

    " 3.2 Assign input values to RETURN structure fields
    et_return-type = iv_type.
    et_return-id = iv_cl.
    et_return-number = iv_number.
    et_return-message_v1 = iv_par1.
    et_return-message_v2 = iv_par2.
    et_return-message_v3 = iv_par3.
    et_return-message_v4 = iv_par4.

    " 3.3 Call the function module OWN_LOGICAL_SYSTEM_GET_STABLE to get the logical system
    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET_STABLE'
      IMPORTING
        ev_logical_system = lv_logical_system.

    " 3.4 Use ABAP MESSAGE command to store message information into RETURN structure
    MESSAGE ID iv_cl TYPE iv_type NUMBER iv_number
        WITH iv_par1 iv_par2 iv_par3 iv_par4
        INTO et_return-message.

    " 3.5 Assign LOG_NO and LOG_MSG_NO to RETURN structure fields
    et_return-log_no = iv_log_no.
    et_return-log_msg_no = iv_log_msg_no.
    et_return-parameter = iv_parameter.
    et_return-row = iv_row.
    et_return-field = iv_field.

  ENDMETHOD.

ENDCLASS.