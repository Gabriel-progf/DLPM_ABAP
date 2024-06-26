*&---------------------------------------------------------------------*
*& Report ZDLPMRP_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdlpmrp_002.

*- [ ]  ALV
*    - [ ]  Equipe
*    - [ ]  % de Eficácia (Com Cor Vermelha (Até 30%), Amarela(Entre 31% e 99%) e Verde(100%))
*    - [ ]  Total Projetos
*    - [ ]  Total Projetos Dentro e Fora do Prazo

TABLES: zdlpmt_003, zdlpmt_004, zdlpmt_009.
INCLUDE: zdlpmrp_003.

SELECTION-SCREEN BEGIN OF BLOCK b1
  WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_squad FOR zdlpmt_004-id.
SELECTION-SCREEN END OF BLOCK b1.

CLASS lcl_main DEFINITION CREATE PRIVATE INHERITING FROM lcl_alv.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_alv,
             equipe              TYPE zdlpmt_004-id,
             equipe_desc         TYPE zdlpmt_004-descricao,
             qtd_projetos        TYPE int4,
             projetos_prazo      TYPE int4,
             projetos_fora_prazo TYPE int4,
             eficacia_equipe     TYPE string,
             eficacia_equipe_txt TYPE string,
             color               TYPE lvc_t_scol,
           END OF ty_alv.
    DATA: lt_alv TYPE TABLE OF ty_alv.

    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_main.

    METHODS:  run,
              get_data     REDEFINITION,
              set_fieldcat REDEFINITION.

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

    " Selecionar as equipes
    SELECT *
      FROM zdlpmt_004
      INTO TABLE @DATA(lt_squads)
      WHERE id IN @s_squad.

    " Selecionar os Projetos e as Horas Estimadas
    SELECT  z003~id,
            z003~equipe,
            SUM( z007~hours_expected ) AS expected
      FROM zdlpmt_003 AS z003
      JOIN zdlpmt_007 AS z007 ON z003~id     = z007~projeto
      JOIN zdlpmt_004 AS z004 ON z003~equipe = z004~id
      INTO TABLE @DATA(lt_projects)
       WHERE z003~equipe IN @s_squad
      GROUP BY z003~id, z003~equipe.

    " Selecionar o somatório das Horas Apontadas de Cada Projeto
    IF lt_projects[] IS NOT INITIAL.

      SELECT  z007~projeto,
              SUM( z009~horas ) AS horas
        FROM zdlpmt_009 AS z009
        JOIN zdlpmt_007 AS z007 ON z009~ticket = z007~id
        INTO TABLE @DATA(lt_hours_by_project)
        GROUP BY z007~projeto.

    ENDIF.

    " Alimentar o ALV de Saída
    LOOP AT lt_squads REFERENCE INTO DATA(lrf_squads).

      " Quantidade de Projetos da Equipe
      DATA(lv_qtd_projetos_equipe) = REDUCE i( INIT count = 0
                                               FOR ls_project IN lt_projects
                                               WHERE ( equipe = lrf_squads->id )
                                               NEXT count = count + 1
                                                ).

      " Projetos no Prazo
      " Projetos Etrasados
      DATA(lv_qtd_projetos_no_prazo)  = 0.
      DATA(lv_qtd_projetos_fora_prazo) = 0.

      LOOP AT lt_projects REFERENCE
        INTO DATA(lrf_project)
        WHERE equipe = lrf_squads->id.

        " Total de Horas Apontadas no Projeto
        DATA(ls_hour) = VALUE #( lt_hours_by_project[ projeto = lrf_project->id ] OPTIONAL ).

        IF ls_hour-horas <= lrf_project->expected.
          lv_qtd_projetos_no_prazo = lv_qtd_projetos_no_prazo + 1.
        ELSE.
          lv_qtd_projetos_fora_prazo = lv_qtd_projetos_fora_prazo + 1.
        ENDIF.

        CLEAR ls_hour.

      ENDLOOP.

      DATA(lv_eficacia) = ( lv_qtd_projetos_no_prazo * 100 ) / lv_qtd_projetos_equipe.

      DATA(lv_color) = COND #( WHEN lv_eficacia >= 1 AND lv_eficacia < 99 THEN 3 WHEN lv_eficacia = 100 THEN 5 ELSE 6 ).
      DATA(lt_color_column) = VALUE lvc_t_scol(
        ( fname = 'EFICACIA_EQUIPE_TXT' color-col = lv_color color-int = 0 color-inv = 0 )
      ).

      APPEND VALUE ty_alv(
        equipe              = lrf_squads->id
        equipe_desc         = lrf_squads->descricao
        qtd_projetos        = lv_qtd_projetos_equipe
        projetos_prazo      = lv_qtd_projetos_no_prazo
        projetos_fora_prazo = lv_qtd_projetos_fora_prazo
        eficacia_equipe     = lv_eficacia
        eficacia_equipe_txt = |{ lv_eficacia }%|
        color               = lt_color_column
      ) TO lt_alv.

    ENDLOOP.

  ENDMETHOD.

  METHOD set_fieldcat.

    fieldcat_change(
      EXPORTING
        _column   = 'EQUIPE'
        _longtxt  = 'Equipe'
        _position = 1
    ).

    fieldcat_change(
      EXPORTING
        _column    = 'EQUIPE_DESC'
        _longtxt   = 'Descrição'
        _position  = 2
        _outputlen = 25
    ).

    fieldcat_change(
      EXPORTING
        _column    = 'QTD_PROJETOS'
        _longtxt   = 'Qtd Projetos'
        _position  = 3
        _outputlen = 15
        _align     = 3
    ).

    fieldcat_change(
      EXPORTING
        _column    = 'PROJETOS_PRAZO'
        _longtxt   = 'Projetos no Prazo'
        _position  = 4
        _outputlen = 15
        _align     = 3
    ).

    fieldcat_change(
      EXPORTING
        _column    = 'PROJETOS_FORA_PRAZO'
        _longtxt   = 'Projetos Fora Prazo'
        _position  = 5
        _outputlen = 15
        _align     = 3
    ).

    fieldcat_change(
      EXPORTING
        _column    = 'EFICACIA_EQUIPE'
        _display   = abap_false
    ).

    fieldcat_change(
      EXPORTING
        _column    = 'EFICACIA_EQUIPE_TXT'
        _longtxt   = 'Eficácia %'
        _position  = 6
        _outputlen = 15
        _align     = 3
    ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl_main=>create( )->run( ).
