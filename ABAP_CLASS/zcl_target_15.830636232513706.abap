Here is the AUNIT test class for the given ABAP class:

```abap
CLASS ltcl_cnv_2010c_test DEFINITION
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: mo_cnv_2010c TYPE REF TO zcl_cnv_2010c.

    METHODS: setup
      TESTING
      TEST-RISK-LEVEL HARMLESS.

    METHODS: positive_test_get_domain_fixed_val
      FOR TESTING
      RAISING cx_static_check.

    METHODS: negative_test_get_domain_fixed_val
      FOR TESTING
      RAISING cx_static_check.

    METHODS: test_fill_bapiret2
      FOR TESTING
      RAISING cx_static_check.
  
ENDCLASS.

CLASS ltcl_cnv_2010c_test IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT mo_cnv_2010c.
  ENDMETHOD.

  METHOD positive_test_get_domain_fixed_val.
    DATA: lt_domain_fixed_val TYPE TABLE OF CNV_2010C_T_DOMAIN_FIXED_VALUE,
          ls_return           TYPE bapiret2,
          lv_domname          TYPE domname.
    
    TRY.
        mo_cnv_2010c->get_domain_fixed_val(
          EXPORTING iv_domname                   = 'ARBPL'
          IMPORTING ev_domname                   = lv_domname
          TABLES et_domain_fixed_val             = lt_domain_fixed_val
                  RETURN                         = RETURN ).

      CATCH cx_static_check INTO DATA(lo_exception).
        cl_aunit_assert=>fail( lo_exception->get_text( ) ).
    ENDTRY.

    cl_aunit_assert=>assert_not_initial( lv_domname ).
    cl_aunit_assert=>assert_not_empty( lt_domain_fixed_val ).
    
  ENDMETHOD.

  METHOD negative_test_get_domain_fixed_val.
    DATA: lt_domain_fixed_val TYPE TABLE OF CNV_2010C_T_DOMAIN_FIXED_VALUE,
          ls_return           TYPE bapiret2,
          lv_domname          TYPE domname.

    TRY.
        mo_cnv_2010c->get_domain_fixed_val(
          EXPORTING iv_domname                   = 'INVALID_DOMNAME'
          IMPORTING ev_domname                   = lv_domname
          TABLES et_domain_fixed_val             = lt_domain_fixed_val
                  RETURN                         = RETURN ).

      CATCH cx_static_check INTO DATA(lo_exception).
        cl_aunit_assert=>fail( lo_exception->get_text( ) ).
    ENDTRY.

    cl_aunit_assert=>assert_initial( lv_domname ).
    cl_aunit_assert=>assert_empty( lt_domain_fixed_val ).
    cl_aunit_assert=>assert_not_empty( RETURN ).

  ENDMETHOD.

  METHOD test_fill_bapiret2.
    DATA: ls_return TYPE bapiret2.
    mo_cnv_2010c->fill_bapiret2(
      EXPORTING type         = 'E'
                cl           = 'CNV_2010C'
                number       = '999'
                par1         = 'Parameter 1'
                par2         = 'Parameter 2'
                log_no       = 'Log 1'
                log_msg_no   = '160'
                parameter    = 'DOMNAME'
                row          = 5
                field        = 'FIELD1'
      IMPORTING RETURN       = ls_return ).

    cl_aunit_assert=>assert_equals(
        act = ls_return-type
        exp = 'E' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-id
        exp = 'CNV_2010C' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-number
        exp = '999' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-message_v1
        exp = 'Parameter 1' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-message_v2
        exp = 'Parameter 2' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-log_no
        exp = 'Log 1' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-log_msg_no
        exp = '160' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-parameter
        exp = 'DOMNAME' ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-row
        exp = 5 ).
    cl_aunit_assert=>assert_equals(
        act = ls_return-field
        exp = 'FIELD1' ).

  ENDMETHOD.

ENDCLASS.
```

This test class includes a setup method to create an instance of the zcl_cnv_2010c class, a positive test scenario for the get_domain_fixed_val method, a negative test scenario for the get_domain_fixed_val method, and a method to test the fill_bapiret2 method.