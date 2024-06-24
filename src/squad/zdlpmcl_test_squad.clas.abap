class ZDLPMCL_TEST_SQUAD definition
  public
  final
  create public
  for testing RISK LEVEL HARMLESS.

public section.

  data GO_SQUAD type ref to ZDLPMCL_003 .
protected section.
private section.

  methods SETUP .
  methods TEARDOWN .
  methods HAS_NO_DESCRIPTION
  for testing
    raising
      ZCX_DLPM_003 .
  methods FILLED
  for testing
    raising
      ZCX_DLPM_003 .
  methods EDIT
  for testing
    raising
      ZCX_DLPM_003 .
  methods DELETE
  for testing
    raising
      ZCX_DLPM_003 .
ENDCLASS.



CLASS ZDLPMCL_TEST_SQUAD IMPLEMENTATION.


  method DELETE.
        "Declarar um sucesso
    DATA(squad) = VALUE zdlpmt_004(
      descricao     = 'Descrição'
    ).

    " Criar o Equipe
    DATA(ls_result_create) = me->go_squad->create(
      CHANGING
        imp_es_data  = squad
    ).

    " Modificando o Equipe
    squad-id = ls_result_create-message_v1.
    squad-descricao = 'Deleted'.

    DATA(ls_result_delete) = me->go_squad->delete( squad ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result_delete-type
        exp                  = 'S'
        msg                  = ls_result_delete-message
    ).

  endmethod.


  METHOD edit.
    "Declarar um sucesso
    DATA(squad) = VALUE zdlpmt_004(
      descricao     = 'Descrição'
    ).

    " Criar o Equipe
    DATA(ls_result_create) = me->go_squad->create(
      CHANGING
        imp_es_data  = squad
    ).


    " Modificando o Equipe
    squad-id = ls_result_create-message_v1.
    squad-descricao = 'Modified'.

    DATA(ls_result_update) = me->go_squad->update(
      CHANGING
        imp_es_data  = squad
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result_update-type
        exp                  = 'S'
        msg                  = ls_result_update-message
    ).

  ENDMETHOD.


  METHOD filled.
    DATA(squad) = VALUE zdlpmt_004(
      descricao = 'Equipe top'
    ).

    DATA(ls_result) = me->go_squad->create(
      CHANGING
        imp_es_data  = squad
    ).

    cl_abap_unit_assert=>assert_equals(
        EXPORTING
          act                  = ls_result-type
          exp                  = 'S'
          msg                  = ls_result-message
      ).

  ENDMETHOD.


  method HAS_NO_DESCRIPTION.

    DATA(squad) = VALUE zdlpmt_004(
      descricao = ''
    ).

    DATA(ls_result) = me->go_squad->create(
      CHANGING
        imp_es_data  = squad
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result-type
        exp                  = 'E'
        msg                  = ls_result-message
    ).

  endmethod.


  method SETUP.
    me->go_squad = NEW zdlpmcl_003( 'ZDLPMT_004' ).
  endmethod.


  method TEARDOWN.
    FREE: me->go_squad.
  endmethod.
ENDCLASS.
