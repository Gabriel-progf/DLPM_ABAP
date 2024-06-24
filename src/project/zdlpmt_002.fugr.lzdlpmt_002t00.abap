*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDLPMT_002......................................*
DATA:  BEGIN OF STATUS_ZDLPMT_002                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDLPMT_002                    .
CONTROLS: TCTRL_ZDLPMT_002
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDLPMT_002                    .
TABLES: ZDLPMT_002                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
