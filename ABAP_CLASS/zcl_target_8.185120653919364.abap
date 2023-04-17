Here's the optimized code using ABAP 7.4 syntax:

```abap
REPORT ZSIMPLE_DBPRG.

CLASS lcl_data_loader DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_mara_data
      IMPORTING
        iv_matnr TYPE matnr
      RETURNING
        VALUE(rs_mara) TYPE mara.
ENDCLASS.

CLASS lcl_data_loader IMPLEMENTATION.
  METHOD get_mara_data.
    SELECT SINGLE * FROM mara INTO CORRESPONDING FIELDS OF rs_mara
      WHERE matnr = iv_matnr.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA: wa_mara TYPE mara.

  wa_mara = lcl_data_loader=>get_mara_data( '00000000000000000023' ).

  IF wa_mara IS NOT INITIAL.
    WRITE: /10 |SELECT SUCCESSFUL|.
  ELSE.
    WRITE: /10 |SELECT NOT SUCCESSFUL|.
  ENDIF.

END-OF-SELECTION.

IF wa_mara IS NOT INITIAL.
  WRITE /10: wa_mara-matnr, |MATERIAL NUMBER|,
             wa_mara-mtart, |MATERIAL TYPE|,
             wa_mara-mbrsh, |INDUSTRY SECTOR|,
             wa_mara-matkl. |MATERIAL ID|.
ELSE.
  WRITE: /10 |wa_mara is empty...|.
ENDIF.
```