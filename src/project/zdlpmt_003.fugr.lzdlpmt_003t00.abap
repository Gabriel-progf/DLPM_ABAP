*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDLPMT_003......................................*
DATA:  BEGIN OF STATUS_ZDLPMT_003                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDLPMT_003                    .
CONTROLS: TCTRL_ZDLPMT_003
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDLPMT_003                    .
TABLES: ZDLPMT_003                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
