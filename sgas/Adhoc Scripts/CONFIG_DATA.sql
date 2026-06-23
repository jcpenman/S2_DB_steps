
SET DEFINE OFF;
Insert into CONFIG_DATA
   (ITEM_NAME, CVAL, NVAL, DVAL)
 Values
   ('SLC_TERMDATES_FILES_TO_BE_PROCESSED_DIR', '/projects/app/webmethods/share/reports/SLC_TermDates/', NULL, NULL);
Insert into CONFIG_DATA
   (ITEM_NAME, CVAL, NVAL, DVAL)
 Values
   ('SLC_TERMDATES_LOG_FILES_DIR', '/projects/app/webmethods/share/reports/SLC_TermDates/logs/', NULL, NULL);
Insert into CONFIG_DATA
   (ITEM_NAME, CVAL, NVAL, DVAL)
 Values
   ('SLC_TERMDATES_PROCESSED_FILES_DIR', '/projects/app/webmethods/share/reports/SLC_TermDates/archive/', NULL, NULL);
COMMIT;
