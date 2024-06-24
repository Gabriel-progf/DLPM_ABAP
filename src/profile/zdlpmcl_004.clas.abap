class ZDLPMCL_004 definition
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



CLASS ZDLPMCL_004 IMPLEMENTATION.


  METHOD validate.
    DATA(wa_perfil) = CORRESPONDING zdlpmt_006( is_data ).

    " Não pode salvar perfil sem ID.
    IF wa_perfil-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

    " Não pode salvar perfil sem descrição.
    IF wa_perfil-descricao IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_description.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
