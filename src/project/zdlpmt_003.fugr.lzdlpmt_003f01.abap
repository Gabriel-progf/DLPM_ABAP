*----------------------------------------------------------------------*
***INCLUDE LZDLPMT_003F01.
*----------------------------------------------------------------------*

FORM modify_register.
  CHECK zdlpmt_003-criado_por IS NOT INITIAL.

  GET TIME STAMP FIELD DATA(lv_timestamp).

  zdlpmt_003-modificado_por = sy-uname.
  zdlpmt_003-modificado_em = lv_timestamp.

ENDFORM.

FORM create_register.

  GET TIME STAMP FIELD DATA(lv_timestamp).

  zdlpmt_003-id = cl_system_uuid=>create_uuid_c32_static( ).
  zdlpmt_003-criado_por = sy-uname.
  zdlpmt_003-criado_em = lv_timestamp.

ENDFORM.
