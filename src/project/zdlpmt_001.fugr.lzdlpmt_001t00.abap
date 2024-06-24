*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDLPMT_001......................................*
DATA:  BEGIN OF STATUS_ZDLPMT_001                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDLPMT_001                    .
CONTROLS: TCTRL_ZDLPMT_001
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDLPMT_001                    .
TABLES: ZDLPMT_001                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
