Refactored the code based on coding guidelines here https://riptutorial.com/abap/topic/6770/naming-conventions 
FUNCTION zcnv_2010c_get_domain_fixed_val.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"      VALUE(IV_DOMNAME) TYPE  DOMNAME
*"  EXPORTING
*"      VALUE(EV_DOMNAME) TYPE  DOMNAME
*"  TABLES
*"      TT_DOMAIN_FIXED_VAL TYPE  ZCNV_2010C_T_DOMAIN_FIXED_VALUE OPTIONAL
*"      TT_RETURN TYPE BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------

  " Data Declaration
  DATA: ls_bapi_ret TYPE bapiret2,
        lt_authority TYPE s_authority.

  " Authorization Check
  CALL FUNCTION 'S_USER_AUTHORITY'
    EXPORTING
      user = sy-uname
    TABLES
      authority = lt_authority.

  IF NOT 'S_TABU_DIS' IN lt_authority[].
    ls_bapi_ret-type = 'E'.
    ls_bapi_ret-message = 'You do not have the necessary authorization.'.
    APPEND ls_bapi_ret TO tt_return.
    RETURN.
  ENDIF.

  " Check if IV_DOMNAME is empty
  IF iv_domname IS INITIAL.
    " Fill BAPIRET2
    CALL FUNCTION 'ZCNV_2010C_FILL_BAPIRET2'
      EXPORTING
        type   = 'E'
        cl     = 'ZCNV_2010C'
        number = '000'
      IMPORTING
        return = ls_bapi_ret.

    ls_bapi_ret-message = text-012.

    APPEND ls_bapi_ret TO tt_return.
    RETURN.
  ENDIF.

  " Select data from table DD07T
  SELECT ddlanguage valpos domvalue_l ddtext
    FROM dd07t INTO CORRESPONDING FIELDS OF TABLE tt_domain_fixed_val
WHERE domname = iv_domname AND ddlanguage EQ sy-langu AND as4local EQ 'A'.

IF sy-subrc EQ 0.
SORT tt_domain_fixed_val ASCENDING BY valpos.
ev_domname = iv_domname.
ELSE.
" Select data from table DD07T for language EQ EN
SELECT ddlanguage valpos domvalue_l ddtext
FROM dd07t INTO CORRESPONDING FIELDS OF TABLE tt_domain_fixed_val
WHERE domname = iv_domname AND ddlanguage EQ 'E' AND as4local EQ 'A'.
IF sy-subrc EQ 0 .
SORT tt_domain_fixed_val ASCENDING BY valpos.
ev_domname = iv_domname.
ELSE.
" Fill BAPIRET2
CALL FUNCTION 'ZCNV_2010C_FILL_BAPIRET2'
EXPORTING
type = 'E'
cl = 'ZCNV_2010C'
number = '000'
IMPORTING
return = ls_bapi_ret.

ls_bapi_ret-message = text-013.

APPEND ls_bapi_ret TO tt_return.
ENDIF.
ENDIF.

ENDFUNCTION.