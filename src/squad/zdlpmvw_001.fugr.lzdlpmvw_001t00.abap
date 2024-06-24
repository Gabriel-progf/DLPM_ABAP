*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDLPMVW_001.....................................*
TABLES: ZDLPMVW_001, *ZDLPMVW_001. "view work areas
CONTROLS: TCTRL_ZDLPMVW_001
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZDLPMVW_001. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZDLPMVW_001.
* Table for entries selected to show on screen
DATA: BEGIN OF ZDLPMVW_001_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZDLPMVW_001.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDLPMVW_001_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZDLPMVW_001_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZDLPMVW_001.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZDLPMVW_001_TOTAL.

*.........table declarations:.................................*
TABLES: ZDLPMT_004                     .
