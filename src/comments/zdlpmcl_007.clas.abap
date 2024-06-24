class ZDLPMCL_007 definition
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



CLASS ZDLPMCL_007 IMPLEMENTATION.


  METHOD validate.

    DATA(wa_comment) = CORRESPONDING zdlpmt_010( is_data ).

    " Não pode salvar comentário sem ID.
    IF wa_comment-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

*   Só continua as validações caso não for deleção.
    CHECK iv_is_delete IS INITIAL.

    " Não pode salvar comentário sem comentário.
    IF wa_comment-comentario IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_comment.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
