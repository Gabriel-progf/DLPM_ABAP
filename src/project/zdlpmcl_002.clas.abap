class ZDLPMCL_002 definition
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



CLASS ZDLPMCL_002 IMPLEMENTATION.


  METHOD validate.

    DATA(wa_projeto) = CORRESPONDING zdlpmt_003( is_data ).

    " Não pode salvar projeto sem ID.
    IF wa_projeto-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

*   Só continua as validações caso não for deleção.
    CHECK iv_is_delete IS INITIAL.

    " Não pode salvar projeto sem titulo.
    IF wa_projeto-titulo IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_title.
    ENDIF.

    " Não pode salvar projeto sem equipe.
    IF wa_projeto-equipe IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_squad.
    ENDIF.

    " Não pode salvar projeto sem responsável.
    IF wa_projeto-titulo IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_owner.
    ENDIF.

    " Não pode salvar projeto sem descrição.
    IF wa_projeto-descricao IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_description.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
