*----------------------------------------------------------------------*
***INCLUDE LZDLPMT_001F01.
*----------------------------------------------------------------------*

FORM MODIFY_REGISTER.

  CHECK zdlpmt_001-criado_por IS NOT INITIAL.

  GET TIME STAMP FIELD DATA(lv_timestamp).

  zdlpmt_001-modificado_por = sy-uname.
  zdlpmt_001-modificado_em = lv_timestamp.

ENDFORM.

FORM CREATE_REGISTER.

  GET TIME STAMP FIELD DATA(lv_timestamp).

  zdlpmt_001-criado_por = sy-uname.
  zdlpmt_001-criado_em = lv_timestamp.

ENDFORM.
