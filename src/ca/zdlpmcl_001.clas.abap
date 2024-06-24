class ZDLPMCL_001 definition
  public
  abstract
  create public .

public section.

  data AV_TABLE type STRING .

  methods CONSTRUCTOR
    importing
      !IV_TABLE type STRING .
  methods READ
    exporting
      !ET_DATA type ANY TABLE
    raising
      ZCX_DLPM_003 .
  methods CREATE
    changing
      !CS_DATA type ANY
    returning
      value(RS_RESULT) type BAPIRET2
    raising
      ZCX_DLPM_003 .
  methods UPDATE
    changing
      !CS_DATA type ANY
    returning
      value(RS_RESULT) type BAPIRET2
    raising
      ZCX_DLPM_003 .
  methods DELETE
    importing
      !IS_DATA type ANY
    returning
      value(RS_RESULT) type BAPIRET2
    raising
      ZCX_DLPM_003 .
  methods VALIDATE
    importing
      !IS_DATA type ANY
      !IV_IS_DELETE type XFELD optional
    raising
      ZCX_DLPM_003 .
protected section.
private section.
ENDCLASS.



CLASS ZDLPMCL_001 IMPLEMENTATION.


  method CONSTRUCTOR.

      me->av_table = iv_table.

  endmethod.


  METHOD create.

    GET TIME STAMP FIELD DATA(lv_timestamp).


    " Preenchando Criado por.
    ASSIGN COMPONENT 'CRIADO_POR' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_criado_por>).
    IF <fs_criado_por> IS ASSIGNED.
      <fs_criado_por> = sy-uname.
    ENDIF.

    " Preenchando Criado em.
    ASSIGN COMPONENT 'CRIADO_EM' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_criado_em>).
    IF <fs_criado_em> IS ASSIGNED.
      <fs_criado_em> = lv_timestamp.
    ENDIF.

    " Preenchando id.
    ASSIGN COMPONENT 'ID' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_id>).
    IF <fs_id> IS ASSIGNED.
      <fs_id> = cl_system_uuid=>create_uuid_c32_static( ).
    ENDIF.

    TRY.
        me->validate( is_data = cs_data ).
      CATCH zcx_dlpm_003 INTO DATA(exc).
        "Erro disparado!
        DATA(lv_msg) = exc->get_text( ).
        rs_result = VALUE bapiret2(
          type = 'E'
          message = lv_msg
        ).
        RETURN.
    ENDTRY.

* Cria registros.
    MODIFY (me->av_table) FROM cs_data.
    rs_result = VALUE bapiret2(
      type = 'S'
      message = 'Criado com sucesso!'
      message_v1 = <fs_id>
    ).
  ENDMETHOD.


  METHOD delete.

    " Buscando referência ID.
    ASSIGN COMPONENT 'ID' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_delete_by_id>).

    TRY.
        me->validate( EXPORTING is_data = is_data iv_is_delete = abap_true ).
      CATCH zcx_dlpm_003 INTO DATA(exc).
        "Erro disparado!
        DATA(lv_msg) = exc->get_text( ).
        rs_result = VALUE bapiret2(
          type = 'E'
          message = lv_msg
        ).
        RETURN.
    ENDTRY.

* Modificado registros.
    DELETE (me->av_table) FROM is_data.
    rs_result = VALUE bapiret2(
      type = 'S'
      message = 'Modificado com sucesso!'
      message_v1 = <fs_delete_by_id>
    ).

  ENDMETHOD.


  METHOD read.

    SELECT *
      FROM (av_table)
      INTO TABLE et_data.

  ENDMETHOD.


  METHOD update.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    " Preenchando Modificado por.
    ASSIGN COMPONENT 'MODIFICADO_POR' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_modificado_por>).
    IF <fs_modificado_por> IS ASSIGNED.
      <fs_modificado_por> = sy-uname.
    ENDIF.

    " Preenchando Modificado em.
    ASSIGN COMPONENT 'MODIFICADO_EM' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_modificado_em>).
    IF <fs_modificado_em> IS ASSIGNED.
      <fs_modificado_em> = lv_timestamp.
    ENDIF.

    " Buscando referência ID.
    ASSIGN COMPONENT 'ID' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_id>).

    TRY.
        me->validate( cs_data ).
      CATCH zcx_dlpm_003 INTO DATA(exc).
        "Erro disparado!
        DATA(lv_msg) = exc->get_text( ).
        rs_result = VALUE bapiret2(
          type = 'E'
          message = lv_msg
        ).
        RETURN.
    ENDTRY.

* Modificado registros.
    MODIFY (me->av_table) FROM cs_data.
    rs_result = VALUE bapiret2(
      type = 'S'
      message = 'Modificado com sucesso!'
      message_v1 = <fs_id>
    ).
  ENDMETHOD.


  METHOD validate.

  ENDMETHOD.
ENDCLASS.
