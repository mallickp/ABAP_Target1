*@AUnit.Test(className = 'ZCL_CNV_2010C_FILL_BAPIRET2')

CLASS ltcl_cnv_2010c_fill_bapiret2 DEFINITION FINAL FOR TESTING
  INHERITING FROM cl_aunit_assert.

  PRIVATE SECTION.

    DATA mo_bapiret2 TYPE REF TO zcl_cnv_2010c_fill_bapiret2.

    METHODS setup_test
      RAISING
        cl_abap_unit_assert=>assertion_failed.

    METHODS: test_fill_bapiret2_positive,
             test_fill_bapiret2_negative,
             test_get_domain_fixed_val_positive,
             test_get_domain_fixed_val_negative.

ENDCLASS.

CLASS ltcl_cnv_2010c_fill_bapiret2 IMPLEMENTATION.

  METHOD setup_test.
    CREATE OBJECT mo_bapiret2.
  ENDMETHOD.

  METHOD test_fill_bapiret2_positive.
    DATA: ls_input_data TYPE zcl_cnv_2010c_fill_bapiret2=>ty_bapiret2_structure,
          ls_expected_result TYPE bapiret2,
          ls_actual_result TYPE bapiret2.

    " Fill ls_input_data with valid values
    ls_input_data = VALUE #( type = 'S'
                             cl = 'ZMSG'
                             number = '123'
                             par1 = 'input1'
                             par2 = 'input2'
                             par3 = 'input3'
                             par4 = 'input4'
                             log_no = '10'
                             log_msg_no = '20'
                             parameter = 'PARAM'
                             row = 2
                             field = 'FIELD1' ).

    " Fill ls_expected_result with the same values as ls_input_data
    ls_expected_result = VALUE #( type = 'S'
                                  id = 'ZMSG'
                                  number = '123'
                                  message_v1 = 'input1'
                                  message_v2 = 'input2'
                                  message_v3 = 'input3'
                                  message_v4 = 'input4'
                                  log_no = '10'
                                  log_msg_no = '20'
                                  parameter = 'PARAM'
                                  row = 2
                                  field = 'FIELD1' ).

    mo_bapiret2->fill_bapiret2( IMPORTING is_input_data = ls_input_data
                                 EXPORTING es_return = ls_actual_result ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_actual_result
      exp = ls_expected_result
      msg = 'Positive scenario, bapiret2 structure was not filled correctly' ).

  ENDMETHOD.

  METHOD test_fill_bapiret2_negative.
    DATA: ls_input_data TYPE zcl_cnv_2010c_fill_bapiret2=>ty_bapiret2_structure,
          ls_expected_result TYPE bapiret2,
          ls_actual_result TYPE bapiret2.

    " Fill ls_input_data with invalid values
    ls_input_data = VALUE #( type = 'I'
                             cl = 'INVALID'
                             number = '000'
                             par1 = 'wrong_input1'
                             par2 = 'wrong_input2'
                             par3 = 'wrong_input3'
                             par4 = 'wrong_input4'
                             log_no = '00'
                             log_msg_no = '00'
                             parameter = 'WRONG_PARAM'
                             row = 0
                             field = 'INVALID_FIELD' ).

    " ls_expected_result should not contain the values from ls_input_data
    ls_expected_result = VALUE #( ).

    mo_bapiret2->fill_bapiret2( IMPORTING is_input_data = ls_input_data
                                 EXPORTING es_return = ls_actual_result ).

    cl_abap_unit_assert=>assert_not_equals(
      act = ls_actual_result
      exp = ls_expected_result
      msg = 'Negative scenario, bapiret2 structure should not be filled with invalid values' ).

  ENDMETHOD.

  METHOD test_get_domain_fixed_val_positive.
    DATA: lt_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value.

    TRY.
        mo_bapiret2->get_domain_fixed_val( IMPORTING iv_domname = 'MYDOM'
                                            TABLES et_domain_fixed_val = lt_domain_fixed_val ).

        cl_abap_unit_assert=>assert_not_initial(
          act = lt_domain_fixed_val
          msg = 'Positive scenario, table should be filled with domain fixed values' ).

    CATCH cx_sy_error_messages.
      cl_abap_unit_assert=>fail( msg = 'Unexpected exception raised' ).
    ENDTRY.

  ENDMETHOD.

  METHOD test_get_domain_fixed_val_negative.
    DATA: lt_domain_fixed_val TYPE cnv_2010c_t_domain_fixed_value.

    TRY.
        mo_bapiret2->get_domain_fixed_val( IMPORTING iv_domname = 'INVALID_DOM'
                                            TABLES et_domain_fixed_val = lt_domain_fixed_val ).

    CATCH cx_sy_error_messages.
      " Expected exception
      RETURN.
    ENDTRY.

    " No exception was raised, but it should have been
    cl_abap_unit_assert=>fail( msg = 'Negative scenario, expected exception not raised' ).

  ENDMETHOD.

ENDCLASS.
