class ZDLPMCL_TEST_PROJECT definition
  public
  final
  create public
  for testing
  risk level harmless .

public section.

  data GO_PROJECT type ref to ZDLPMCL_002 .
  PROTECTED SECTION.
private section.

  methods SETUP .
  methods TEARDOWN .
  methods HAS_NO_TITLE
  for testing
    raising
      ZCX_DLPM_003 .
  methods HAS_NO_DESCRIPTION
  for testing
    raising
      ZCX_DLPM_003 .
  methods HAS_NO_SQUAD
  for testing
    raising
      ZCX_DLPM_003 .
  methods HAS_NO_OWNER
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



CLASS ZDLPMCL_TEST_PROJECT IMPLEMENTATION.


  METHOD delete.

    "Declarar um sucesso
    DATA(project) = VALUE zdlpmt_003(
      titulo        = 'Título'
      descricao     = 'Descrição'
      modulo        = 'FI'
      setor         = '1'
      equipe        = '1'
      responsavel   = 'GOLIVEIRA'
      data_inicio   = '20221118'
      data_fim      = '20221131'
      data_fim_real = ''
    ).

    " Criar o projeto
    DATA(ls_result_create) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).


    " Modificando o Projeto
    project-id = ls_result_create-message_v1.
    project-descricao = 'Deleted'.

    DATA(ls_result_delete) = me->go_project->delete( project ).

    cl_abap_unit_assert=>assert_equals(
  EXPORTING
    act                  = ls_result_delete-type
    exp                  = 'S'
    msg                  = ls_result_delete-message
).


  ENDMETHOD.


  METHOD edit.

    "Declarar um sucesso
    DATA(project) = VALUE zdlpmt_003(
      titulo        = 'Título'
      descricao     = 'Descrição'
      modulo        = 'FI'
      setor         = '1'
      equipe        = '1'
      responsavel   = 'GOLIVEIRA'
      data_inicio   = '20221118'
      data_fim      = '20221131'
      data_fim_real = ''
    ).

    " Criar o projeto
    DATA(ls_result_create) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).


    " Modificando o Projeto
    project-id = ls_result_create-message_v1.
    project-descricao = 'Modified'.

    DATA(ls_result_update) = me->go_project->update(
      CHANGING
        imp_es_data  = project
    ).

    cl_abap_unit_assert=>assert_equals(
  EXPORTING
    act                  = ls_result_update-type
    exp                  = 'S'
    msg                  = ls_result_update-message
).


  ENDMETHOD.


  METHOD filled.
    DATA(project) = VALUE zdlpmt_003(
      titulo        = 'Título'
      descricao     = 'Descrição'
      modulo        = 'FI'
      setor         = '1'
      equipe        = '1'
      responsavel   = 'GOLIVEIRA'
      data_inicio   = '20221118'
      data_fim      = '20221131'
      data_fim_real = ''
    ).

    DATA(ls_result) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result-type
        exp                  = 'S'
        msg                  = ls_result-message
    ).

  ENDMETHOD.


  METHOD has_no_description.

    DATA(project) = VALUE zdlpmt_003(
  descricao     = ''
  modulo        = 'FI'
  setor         = '1'
  equipe        = '1'
  responsavel   = 'GOLIVEIRA'
  data_inicio   = '20221118'
  data_fim      = '20221131'
  data_fim_real = ''
).

    DATA(ls_result) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result-type
        exp                  = 'E'
        msg                  = ls_result-message
    ).

  ENDMETHOD.


  METHOD has_no_owner.
    DATA(project) = VALUE zdlpmt_003(
  descricao     = 'Descrição'
  modulo        = 'FI'
  setor         = '1'
  equipe        = '1'
  responsavel   = ''
  data_inicio   = '20221118'
  data_fim      = '20221131'
  data_fim_real = ''
).

    DATA(ls_result) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result-type
        exp                  = 'E'
        msg                  = ls_result-message
    ).

  ENDMETHOD.


  METHOD has_no_squad.
    DATA(project) = VALUE zdlpmt_003(
  descricao     = 'Descrição'
  modulo        = 'FI'
  setor         = '1'
  equipe        = ''
  responsavel   = 'GOLIVEIRA'
  data_inicio   = '20221118'
  data_fim      = '20221131'
  data_fim_real = ''
).

    DATA(ls_result) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result-type
        exp                  = 'E'
        msg                  = ls_result-message
    ).

  ENDMETHOD.


  METHOD has_no_title.

    DATA(project) = VALUE zdlpmt_003(
      descricao     = 'Descrição'
      modulo        = 'FI'
      setor         = '1'
      equipe        = '1'
      responsavel   = 'GOLIVEIRA'
      data_inicio   = '20221118'
      data_fim      = '20221131'
      data_fim_real = ''
    ).

    DATA(ls_result) = me->go_project->create(
      CHANGING
        imp_es_data  = project
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = ls_result-type
        exp                  = 'E'
        msg                  = ls_result-message
    ).

  ENDMETHOD.


  METHOD setup.

    me->go_project = NEW zdlpmcl_002( 'ZDLPMT_003' ).

  ENDMETHOD.


  METHOD teardown.
    FREE: me->go_project.
  ENDMETHOD.
ENDCLASS.
