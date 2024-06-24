class ZDLPMCL_003 definition
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



CLASS ZDLPMCL_003 IMPLEMENTATION.


  METHOD validate.
    DATA(wa_squad) = CORRESPONDING zdlpmt_004( is_data ).

    " Não pode salvar equipe sem ID.
    IF wa_squad-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

    " Não pode salvar equipe sem descrição.
    IF wa_squad-descricao IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_description.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
