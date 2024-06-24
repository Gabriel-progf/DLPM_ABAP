CLASS lcl_busines_proj DEFINITION.

  PUBLIC SECTION.
    DATA: lt_projeto TYPE TABLE OF zdlpmt_003,
          lo_projeto TYPE REF TO zdlpmcl_002.

    METHODS: constructor,
      get_projeto,
      set_projeto IMPORTING VALUE(it_projeto) TYPE any,
      delete_projeto IMPORTING VALUE(it_deleted_rows) TYPE lvc_t_moce.

ENDCLASS.

CLASS lcl_busines_proj IMPLEMENTATION.

  METHOD constructor.
    lo_projeto = NEW zdlpmcl_002( iv_table = 'ZDLPMT_003' ).
  ENDMETHOD.

  METHOD get_projeto.

    lo_projeto->read( IMPORTING et_data = lt_projeto ).

  ENDMETHOD.

  METHOD set_projeto.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    DATA(lt_mod_projeto) = CONV zdlpmtt_003( it_projeto ).

    LOOP AT lt_mod_projeto INTO DATA(ls_projeto).
      ls_projeto-criado_em = lv_timestamp.
      ls_projeto-criado_por = sy-uname.

      ls_projeto-modificado_em = lv_timestamp.
      ls_projeto-modificado_por = sy-uname.

      IF ls_projeto-id EQ space. " igual vazio
        DATA(ls_return_create) = lo_projeto->create( CHANGING cs_data = ls_projeto ).
      ELSE.
        DATA(ls_return_update) = lo_projeto->update( CHANGING cs_data = ls_projeto ).
      ENDIF.

      DATA(is_error_message_create) = COND #( WHEN ls_return_create-type NE 'S' THEN 'X' ELSE ' ' ).
      DATA(is_error_message_updata) = COND #( WHEN ls_return_update NE 'S' THEN 'X' ELSE ' ' ).

      IF is_error_message_create eq 'X'.
        MESSAGE ls_return_create-message TYPE ls_return_create-type.
        CONTINUE.
      ELSEIF is_error_message_updata eq 'X'.
        MESSAGE ls_return_update-message TYPE ls_return_update-type.
        CONTINUE.
      ENDIF.

    ENDLOOP.

    MESSAGE 'Registros processados com sucesso!' TYPE 'S'.

    COMMIT WORK.

  ENDMETHOD.

  METHOD delete_projeto.

    CHECK it_deleted_rows[] IS NOT INITIAL.

    LOOP AT it_deleted_rows INTO DATA(ls_deleted_rows).

      DATA(ls_projeto) = lt_projeto[ ls_deleted_rows-row_id ].
      DATA(ls_return_delete) = lo_projeto->delete( is_data = ls_projeto ).
      CLEAR ls_projeto.

      MESSAGE ls_return_delete-message TYPE ls_return_delete-type.

    ENDLOOP.

    MESSAGE 'Registros processados com sucesso!' TYPE 'S'.

    COMMIT WORK.

  ENDMETHOD.

ENDCLASS.
