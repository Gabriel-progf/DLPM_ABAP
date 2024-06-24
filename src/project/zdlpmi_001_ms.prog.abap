CLASS lcl_busines_ms DEFINITION.

  PUBLIC SECTION.
    DATA: lt_modulo_sap TYPE TABLE OF zdlpmt_002.

    METHODS: get_modulo_sap,
      set_modulo_sap IMPORTING VALUE(it_modulo_sap) TYPE any,
      delete_modulo_sap IMPORTING VALUE(it_deleted_rows) TYPE lvc_t_moce.

ENDCLASS.

CLASS lcl_busines_ms IMPLEMENTATION.

  METHOD get_modulo_sap.

    SELECT *
      FROM zdlpmt_002
      INTO TABLE lt_modulo_sap.

  ENDMETHOD.

  METHOD set_modulo_sap.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    DATA(lt_mod_modulo_sap) = CONV zdlpmtt_002( it_modulo_sap ).

    LOOP AT lt_mod_modulo_sap INTO DATA(ls_modulo_sap).
      ls_modulo_sap-criado_em = lv_timestamp.
      ls_modulo_sap-criado_por = sy-uname.

      ls_modulo_sap-modificado_em = lv_timestamp.
      ls_modulo_sap-modificado_por = sy-uname.

      MODIFY zdlpmt_002 FROM ls_modulo_sap.

    ENDLOOP.

    MESSAGE 'Registros processados com sucesso!' TYPE 'S'.

    COMMIT WORK.

  ENDMETHOD.

  METHOD delete_modulo_sap.

    CHECK it_deleted_rows[] IS NOT INITIAL.

    LOOP AT it_deleted_rows INTO DATA(ls_deleted_rows).
      DATA(ls_modulo_sap) = lt_modulo_sap[ ls_deleted_rows-row_id ].
      DELETE FROM zdlpmt_002 WHERE modulo = ls_modulo_sap-modulo.
      CLEAR ls_modulo_sap.
    ENDLOOP.

    MESSAGE 'Registros processados com sucesso!' TYPE 'S'.

    COMMIT WORK.

  ENDMETHOD.

ENDCLASS.
