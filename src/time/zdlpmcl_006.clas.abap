class ZDLPMCL_006 definition
  public
  inheriting from ZDLPMCL_001
  final
  create public .

public section.

  methods APPROVE_HOUR
    importing
      !IV_APPROVE type ZDLPMEL_010
    changing
      !CS_DATA type ZDLPMT_009
    returning
      value(RS_RESULT) type BAPIRET2 .

  methods VALIDATE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZDLPMCL_006 IMPLEMENTATION.


  METHOD approve_hour.

    " Só aprova ou reprova
    CHECK iv_approve CA 'AR'.

    " Modifica o valor de Entrada
    cs_data-aprovacao = iv_approve.
    cs_data-aprovado_em = sy-datum.
    cs_data-aprovado_por = sy-uname.

    MODIFY zdlpmt_009 FROM cs_data.

  ENDMETHOD.


  METHOD VALIDATE.

    DATA(wa_hour) = CORRESPONDING zdlpmt_008( is_data ).

    " Não pode salvar hour sem ID.
    IF wa_hour-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

*   Só continua as validações caso não for deleção.
    CHECK iv_is_delete IS INITIAL.

    " Não pode salvar hour sem descrição.
    IF wa_hour-descricao IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_description.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
