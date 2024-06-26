*&---------------------------------------------------------------------*
*& Report ZDLPMRP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdlpmrp_001.

*- [ ]  ALV
*    - [X]  Projeto
*        - [ ]  Navegando para Tela Projeto
*        - [ ]  Botão para Finalizar Projeto
*    - [X]  % de Conclusão (Com Cor Vermelha (Acima 100%), Amarela(Entre 50% e 99%) e Verde(100%))
*    - [X]  Total de Horas Estimadas
*    - [X]  Total de Horas Apontadas

TABLES: zdlpmt_009,
        zdlpmt_003,
        zdlpmt_007.
INCLUDE: zdlpmrp_003.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_proj FOR zdlpmt_003-id.
SELECTION-SCREEN END OF BLOCK b1.

CLASS lcl_main DEFINITION CREATE PRIVATE INHERITING FROM lcl_alv.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_alv,
            projeto         TYPE zdlpmt_003-id,
            titulo          TYPE zdlpmt_003-titulo,
            total_horas     TYPE int4,
            total_apontado  TYPE int4,
            progresso       TYPE int4,
            progresso_txt   TYPE string,
            color           TYPE lvc_t_scol,
           END OF ty_alv.
    DATA: lt_alv TYPE TABLE OF ty_alv.

    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_main.

    METHODS:  run,                       " Executa a Sequencia de Métodos da Clase
              get_data     REDEFINITION, " Seleciona os Projetos
              set_fieldcat REDEFINITION. " Modifica as Colunas


  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT r_result.
  ENDMETHOD.

  METHOD run.

    get_data( ).
    display_report( CHANGING lt_alv = lt_alv ).

  ENDMETHOD.

  METHOD get_data.

    " Selecionar os Projetos com o Somatório das Horas Esperadas (Tickets)
    SELECT  z003~id,
            z003~titulo,
            sum( z007~hours_expected ) AS expected
      FROM zdlpmt_003 AS z003
      LEFT JOIN zdlpmt_007 AS z007 ON z003~id = z007~projeto
      INTO TABLE @DATA(lt_projects)
      WHERE z003~id IN @s_proj
      GROUP BY z003~id, z003~titulo.

    " Somatório de Horas Apontadas por Projeto
    SELECT z007~projeto, sum( z009~horas ) AS horas
      FROM zdlpmt_009 AS z009
      LEFT JOIN zdlpmt_007 AS z007 ON z009~ticket = z007~id
      INTO TABLE @DATA(lt_hours)
      WHERE aprovacao    = 'A' AND
            z007~projeto IN @s_proj
      GROUP BY z007~projeto.

    LOOP AT lt_projects REFERENCE INTO DATA(lrf_project).

      " Filtrando as Horas Apontadas do Projeto
      DATA(ls_hour) = VALUE #( lt_hours[ projeto = lrf_project->id ] OPTIONAL ).

      " Calculando o Progresso
      DATA(lv_progresso) = ( ls_hour-horas * 100 ) / lrf_project->expected.

      " Controle de Cores
      DATA(lv_color) = COND #(
        WHEN lv_progresso >= 50 AND lv_progresso <= 99 THEN 3
        WHEN lv_progresso = 100 THEN 5
        WHEN lv_progresso > 100 THEN 6
        ELSE 4
      ).
      DATA(lt_color_column) = VALUE lvc_t_scol(
        ( fname = 'PROGRESSO_TXT' color-col = lv_color )
      ).

      " Adiciona a Linha ao Relatório
      APPEND VALUE ty_alv(  projeto         = lrf_project->id
                            titulo          = lrf_project->titulo
                            total_horas     = lrf_project->expected
                            total_apontado  = ls_hour-horas
                            progresso       = lv_progresso
                            progresso_txt   = |{ lv_progresso }%|
                            color           = lt_color_column ) TO lt_alv.

    ENDLOOP.

  ENDMETHOD.

  METHOD set_fieldcat.

    fieldcat_change(
      _column   = 'PROJETO'
      _longtxt  = 'Projeto'
      _position = 1
    ).

    fieldcat_change(
      _column    = 'TITULO'
      _longtxt   = 'Título'
      _position  = 2
      _outputlen = 25
    ).

    fieldcat_change(
      _column    = 'TOTAL_HORAS'
      _longtxt   = 'Total Horas'
      _position  = 3
      _outputlen = 15
      _align     = 3
    ).

    fieldcat_change(
      _column    = 'TOTAL_APONTADO'
      _longtxt   = 'Total Apontado'
      _position  = 4
      _outputlen = 15
      _align     = 3
    ).

    fieldcat_change(
      _column    = 'PROGRESSO'
      _display   = abap_false
    ).

    fieldcat_change(
      _column    = 'PROGRESSO_TXT'
      _longtxt   = 'Progresso %'
      _position  = 5
      _outputlen = 15
      _align     = 3
    ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl_main=>create( )->run( ).
