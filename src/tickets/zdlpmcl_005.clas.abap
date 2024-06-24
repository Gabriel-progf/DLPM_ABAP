class ZDLPMCL_005 definition
  public
  inheriting from ZDLPMCL_001
  final
  create public .

public section.

  methods VALIDATE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZDLPMCL_005 IMPLEMENTATION.


  METHOD validate.

    DATA(wa_ticket) = CORRESPONDING zdlpmt_007( is_data ).

    " Não pode salvar ticket sem ID.
    IF wa_ticket-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

*   Só continua as validações caso não for deleção.
    CHECK iv_is_delete IS INITIAL.

    " Não pode salvar ticket sem titulo.
    IF wa_ticket-titulo IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_title.
    ENDIF.

    " Não pode salvar ticket sem descrição.
    IF wa_ticket-descricao IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_description.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
