*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDLPMT_006......................................*
DATA:  BEGIN OF STATUS_ZDLPMT_006                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDLPMT_006                    .
CONTROLS: TCTRL_ZDLPMT_006
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZDLPMT_006                    .
TABLES: ZDLPMT_006                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
