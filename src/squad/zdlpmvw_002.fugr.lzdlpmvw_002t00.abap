*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDLPMVW_002.....................................*
TABLES: ZDLPMVW_002, *ZDLPMVW_002. "view work areas
CONTROLS: TCTRL_ZDLPMVW_002
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZDLPMVW_002. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZDLPMVW_002.
* Table for entries selected to show on screen
DATA: BEGIN OF ZDLPMVW_002_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZDLPMVW_002.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDLPMVW_002_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZDLPMVW_002_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZDLPMVW_002.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDLPMVW_002_TOTAL.

*.........table declarations:.................................*
TABLES: ZDLPMT_005                     .
