class ZDLPMCL_008 definition
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



CLASS ZDLPMCL_008 IMPLEMENTATION.


  METHOD validate.

    DATA(wa_notification) = CORRESPONDING zdlpmt_011( is_data ).

    " Não pode salvar notificação sem ID.
    IF wa_notification-id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_id.
    ENDIF.

*   Só continua as validações caso não for deleção.
    CHECK iv_is_delete IS INITIAL.

    " Não pode salvar notificação sem ticket.
    IF wa_notification-ticket IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_ticket.
    ENDIF.

    " Não pode salvar notificação sem usuário.
    IF wa_notification-usuario IS INITIAL.
      RAISE EXCEPTION TYPE zcx_dlpm_003
        EXPORTING
          textid = zcx_dlpm_003=>has_no_user.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
