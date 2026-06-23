CREATE INDEX SGAS.BENEFACTOR_INCOME_AUD_IND1 ON SGAS.BENEFACTOR_INCOME_AUD
(TABLE_PKEY1, COLUMN_NAME)
LOGGING
STORAGE    (
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;
/


BEGIN
  SYS.DBMS_STATS.GATHER_INDEX_STATS (
     OwnName           => 'SGAS'
    ,IndName           => 'BENEFACTOR_INCOME_AUD_IND1'
    ,Estimate_Percent  => 10
    ,Degree            => 4
    ,No_Invalidate  => FALSE);
END;
/