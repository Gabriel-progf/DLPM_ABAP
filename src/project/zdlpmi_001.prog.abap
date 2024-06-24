*&---------------------------------------------------------------------*
*& Modulpool  ZDLPMI_001
*&
*&---------------------------------------------------------------------*
PROGRAM zdlpmi_001.
" Customização do container de tela
DATA: go_custom_controle TYPE REF TO cl_gui_custom_container,
      " Lista
      go_grid            TYPE REF TO cl_gui_alv_grid,
      " Caracteristicas da Coluna
      gt_fieldcat        TYPE lvc_t_fcat,
      " Caracteristicas da Lista
      gs_layout          TYPE lvc_s_layo.

INCLUDE: zdlpmi_001_se,
         zdlpmi_001_ms,
         zdlpmi_001_proj.

CLASS lcl_busines DEFINITION.

  PUBLIC SECTION.
    DATA: lv_screen       TYPE string,
          lo_busines_se   TYPE REF TO lcl_busines_se,
          lo_busines_ms   TYPE REF TO lcl_busines_ms,
          lo_busines_proj TYPE REF TO lcl_busines_proj.

    METHODS: constructor IMPORTING VALUE(iv_screen) TYPE string,
      run,
      run_setor_empresa,
      run_modulo_sap,
      run_projeto,
      active_change_handle,
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,
      refresh.

ENDCLASS.

CLASS lcl_busines IMPLEMENTATION.
  METHOD constructor.

    lv_screen = iv_screen.
    lo_busines_se = NEW lcl_busines_se( ).
    lo_busines_ms = NEW lcl_busines_ms( ).
    lo_busines_proj = NEW lcl_busines_proj( ).

  ENDMETHOD.

  METHOD run.
    lv_screen = COND #( WHEN lv_screen NS 'RUN_' THEN |RUN_{ lv_screen }| ELSE lv_screen ).
    CALL METHOD (lv_screen).
  ENDMETHOD.

  METHOD refresh.
    " Para exiber os dados no grid atualizado!
    go_grid->refresh_table_display( ).
    cl_gui_cfw=>flush( ).
  ENDMETHOD.

  METHOD handle_data_changed.

    " Retorna as linhas inseridas ou modificadas da grid!
    ASSIGN er_data_changed->mp_mod_rows->* TO FIELD-SYMBOL(<modify_rows>).

    " Retorna as linhas que foram deletadas pela grid!
    ASSIGN er_data_changed->mt_deleted_rows TO FIELD-SYMBOL(<delered_rows>).

    CASE lv_screen.
      WHEN 'RUN_SETOR_EMPRESA'.
        lo_busines_se->set_setor_empresa( <modify_rows> ).
        lo_busines_se->delete_setor_empresa( <delered_rows> ).
      WHEN 'RUN_MODULO_SAP'.
        lo_busines_ms->set_modulo_sap( <modify_rows> ).
        lo_busines_ms->delete_modulo_sap( <delered_rows> ).
      WHEN 'RUN_PROJETO'.
        lo_busines_proj->set_projeto( <modify_rows> ).
        lo_busines_proj->delete_projeto( <delered_rows> ).
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD active_change_handle.
    " Função que armazena se houve alguma modificação na GRID(go_grid)!
    go_grid->check_changed_data( ).
  ENDMETHOD.

  METHOD run_setor_empresa.

    CHECK go_custom_controle IS INITIAL.

    " Atrelando um componente de tela a um obejto ABAP
    go_custom_controle = NEW cl_gui_custom_container( 'CC_SETOR_EMPRESA' ).

    " Atrelando a GRID a um objeto ABAP de tela
    go_grid = NEW cl_gui_alv_grid( i_parent = go_custom_controle ).

    " Função para edição de colunas
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZDLPMT_001'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).
      CASE <fs_fieldcat>-fieldname.
        WHEN 'SETOR'.
          <fs_fieldcat>-just = 'C'.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'DESCRICAO'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'MODIFICADO_EM'.
          <fs_fieldcat>-reptext   = 'Mod. Em'.
          <fs_fieldcat>-scrtext_s = 'Mod. Em'.
          <fs_fieldcat>-scrtext_m = 'Modificado Em'.
          <fs_fieldcat>-scrtext_l = 'Modificado Em'.
        WHEN 'MODIFICADO_POR'.
          <fs_fieldcat>-reptext   = 'Mod. Por'.
          <fs_fieldcat>-scrtext_s = 'Mod. Por'.
          <fs_fieldcat>-scrtext_m = 'Modificado Por'.
          <fs_fieldcat>-scrtext_l = 'Modificado Por'.
        WHEN OTHERS.
          <fs_fieldcat>-no_out = 'X'.
      ENDCASE.
    ENDLOOP.

    " Iniciando a GRID
    go_grid->set_table_for_first_display(
      EXPORTING
        i_structure_name              = 'ZDLPMT_001'
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = lo_busines_se->lt_setor_empresa
        it_fieldcatalog               = gt_fieldcat
    ).

    " manipula o conjunto de informações adicionadas na go_grid.
    SET HANDLER handle_data_changed FOR go_grid.

    refresh( ).

  ENDMETHOD.

  METHOD run_modulo_sap.

    CHECK go_custom_controle IS INITIAL.

    " Atrelando um componente de tela a um obejto ABAP
    go_custom_controle = NEW cl_gui_custom_container( 'CC_MODULO_SAP' ).

    " Atrelando a GRID a um objeto ABAP de tela
    go_grid = NEW cl_gui_alv_grid( i_parent = go_custom_controle ).

    " Função para edição de colunas
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZDLPMT_002'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).
      CASE <fs_fieldcat>-fieldname.
        WHEN 'MODULO'.
          <fs_fieldcat>-just = 'C'.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'MODIFICADO_EM'.
          <fs_fieldcat>-reptext   = 'Mod. Em'.
          <fs_fieldcat>-scrtext_s = 'Mod. Em'.
          <fs_fieldcat>-scrtext_m = 'Modificado Em'.
          <fs_fieldcat>-scrtext_l = 'Modificado Em'.
        WHEN 'MODIFICADO_POR'.
          <fs_fieldcat>-reptext   = 'Mod. Por'.
          <fs_fieldcat>-scrtext_s = 'Mod. Por'.
          <fs_fieldcat>-scrtext_m = 'Modificado Por'.
          <fs_fieldcat>-scrtext_l = 'Modificado Por'.
        WHEN OTHERS.
          <fs_fieldcat>-no_out = 'X'.
      ENDCASE.
    ENDLOOP.

    " Iniciando a GRID
    go_grid->set_table_for_first_display(
      EXPORTING
        i_structure_name              = 'ZDLPMT_002'
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = lo_busines_ms->lt_modulo_sap
        it_fieldcatalog               = gt_fieldcat
    ).

    " manipula o conjunto de informações adicionadas na go_grid.
    SET HANDLER handle_data_changed FOR go_grid.

    refresh( ).


  ENDMETHOD.

  METHOD run_projeto.

    CHECK go_custom_controle IS INITIAL.

    " Atrelando um componente de tela a um obejto ABAP
    go_custom_controle = NEW cl_gui_custom_container( 'CC_PROJETO' ).

    " Atrelando a GRID a um objeto ABAP de tela
    go_grid = NEW cl_gui_alv_grid( i_parent = go_custom_controle ).

    " Função para edição de colunas
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZDLPMT_003'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).
      CASE <fs_fieldcat>-fieldname.
        WHEN 'TITULO'.
          <fs_fieldcat>-just = 'C'.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'DESCRICAO'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'MODULO'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'SETOR'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'EQUIPE'.
          <fs_fieldcat>-reptext   = 'Equipe'.
          <fs_fieldcat>-scrtext_s = 'Equipe'.
          <fs_fieldcat>-scrtext_m = 'Equipe'.
          <fs_fieldcat>-scrtext_l = 'Equipe'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'RESPONSAVEL'.
          <fs_fieldcat>-reptext   = 'Reponsável'.
          <fs_fieldcat>-scrtext_s = 'Reponsável'.
          <fs_fieldcat>-scrtext_m = 'Reponsável'.
          <fs_fieldcat>-scrtext_l = 'Reponsável'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'DATA_INICIO'.
          <fs_fieldcat>-reptext   = 'Data Inicio'.
          <fs_fieldcat>-scrtext_s = 'Data Inicio'.
          <fs_fieldcat>-scrtext_m = 'Data Inicio'.
          <fs_fieldcat>-scrtext_l = 'Data Inicio'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'DATA_FIM'.
          <fs_fieldcat>-reptext   = 'Data Fim'.
          <fs_fieldcat>-scrtext_s = 'Data Fim'.
          <fs_fieldcat>-scrtext_m = 'Data Fim'.
          <fs_fieldcat>-scrtext_l = 'Data Fim'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN 'DATA_FIM_REAL'.
          <fs_fieldcat>-reptext   = 'Data Fim Real'.
          <fs_fieldcat>-scrtext_s = 'Data Fim Real'.
          <fs_fieldcat>-scrtext_m = 'Data Fim Real'.
          <fs_fieldcat>-scrtext_l = 'Data Fim Real'.
          <fs_fieldcat>-outputlen = 15.
          <fs_fieldcat>-edit      = 'X'.
        WHEN OTHERS.
          <fs_fieldcat>-no_out = 'X'.
      ENDCASE.
    ENDLOOP.

    " Iniciando a GRID
    go_grid->set_table_for_first_display(
      EXPORTING
        i_structure_name              = 'ZDLPMT_003'
        is_layout                     = gs_layout
      CHANGING
        it_outtab                     = lo_busines_proj->lt_projeto
        it_fieldcatalog               = gt_fieldcat
    ).

    " manipula o conjunto de informações adicionadas na go_grid.
    SET HANDLER handle_data_changed FOR go_grid.

    refresh( ).

  ENDMETHOD.

ENDCLASS.

DATA lo_busines TYPE REF TO lcl_busines.

MODULE set_status OUTPUT.

  IF lo_busines IS INITIAL.
    lo_busines = NEW lcl_busines( COND #(
    WHEN sy-dynnr EQ '2001' THEN 'PROJETO'
    WHEN sy-dynnr EQ '2002' THEN 'SETOR_EMPRESA'
    ELSE 'MODULO_SAP'
    )
    ).

  ENDIF.
  lo_busines->run( ).

  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR sy-dynnr.
ENDMODULE.

MODULE set_command INPUT.
  CASE sy-ucomm.
    WHEN '&F03' OR '&F15' OR '&F12'.
      LEAVE PROGRAM.
    WHEN 'BTN_SETOR_EMPRESA'.
      lo_busines->lo_busines_se->get_setor_empresa( ).
      lo_busines->refresh( ).
    WHEN 'BTN_MODULO_SAP'.
      lo_busines->lo_busines_ms->get_modulo_sap( ).
      lo_busines->refresh( ).
    WHEN 'BTN_PROJETO'.
      lo_busines->lo_busines_proj->get_projeto( ).
      lo_busines->refresh( ).
    WHEN 'BTN_SE_SAVE' OR 'BTN_MS_SAVE' or 'BTN_PROJ_SAVE'.
      lo_busines->active_change_handle( ).
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
