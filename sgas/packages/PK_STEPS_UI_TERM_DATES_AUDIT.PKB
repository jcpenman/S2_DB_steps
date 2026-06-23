CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_TERM_DATES_AUDIT
AS
   FUNCTION getDefaultDateFrom
      RETURN VARCHAR2
   IS
      DEFAULT_DATE_FROM_STR   VARCHAR2 (10) := '01/01/1970';
   BEGIN
      RETURN DEFAULT_DATE_FROM_STR;
   END getDefaultDateFrom;


   FUNCTION getDefaultDateTo
      RETURN VARCHAR2
   IS
      DEFAULT_DATE_TO_STR   VARCHAR2 (10) := '01/01/2100';
   BEGIN
      RETURN DEFAULT_DATE_TO_STR;
   END getDefaultDateTo;


   PROCEDURE getInstAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      instAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN instAudDetails_cursor FOR
         SELECT ROWNUM, 'INST' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          AUD.TABLE_PKEY1 AS INST_CODE,
                          I.INST_NAME,
                          DECODE (AUD.COLUMN_NAME,
                                  'HOUSE_NO_OR_NAME', 'PROPERTY_ID',
                                  AUD.COLUMN_NAME)
                             AS COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM INST_AUD AUD, INST I
                    WHERE     AUD.TABLE_PKEY1 = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('ADDR_L1',
                                  'ADDR_L2',
                                  'ADDR_L3',
                                  'ADDR_L4',
                                  'HEI_INST_CODE',
                                  'HOUSE_NO_OR_NAME',
                                  'INST_CODE',
                                  'INST_NAME',
                                  'INST_TYPE_ID',
                                  'LOCATION_IND',
                                  'NON_PUBLIC_FUND',
                                  'PAMS',
                                  'POST_CODE',
                                  'TELE_NO')
                          AND I.INST_CODE =
                                 NVL (UPPER (instCode_in), I.INST_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC) X;

      io_cursor := instAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstAudDetails;


   PROCEDURE getInstTermAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      instTermAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN instTermAudDetails_cursor FOR
         SELECT ROWNUM, 'INST_TERM' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          AUD.TABLE_PKEY1 AS INST_CODE,
                          I.INST_NAME,
                          AUD.TABLE_PKEY2 AS SESSION_CODE,
                          AUD.TABLE_PKEY3 AS TERM_NO,
                          AUD.COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM INST_TERM_AUD AUD, INST I
                    WHERE     AUD.TABLE_PKEY1 = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('DAYS',
                                  'END_DATE',
                                  'SESSION_CODE',
                                  'START_DATE',
                                  'TERM_NO')
                          AND I.INST_CODE =
                                 NVL (UPPER (instCode_in), I.INST_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC) X;

      io_cursor := instTermAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstTermAudDetails;


   PROCEDURE getCampusAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      campusAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN campusAudDetails_cursor FOR
         SELECT ROWNUM, 'CAMPUS' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          C.INST_CODE,
                          I.INST_NAME,
                          C.NAME AS CAMPUS_NAME,
                          DECODE (AUD.COLUMN_NAME,
                                  'HOUSE_NO_NAME', 'PROPERTY_ID',
                                  AUD.COLUMN_NAME)
                             AS COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM CAMPUS_AUD AUD, CAMPUS C, INST I
                    WHERE     AUD.TABLE_PKEY1 = C.CAMPUS_ID
                          AND C.INST_CODE = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('ADDR_L1',
                                  'ADDR_L2',
                                  'ADDR_L3',
                                  'ADDR_L4',
                                  'CAMPUS_CODE',
                                  'HOUSE_NO_NAME',
                                  'NAME',
                                  'POSTCODE')
                          AND I.INST_CODE =
                                 NVL (UPPER (instCode_in), I.INST_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC) X;

      io_cursor := campusAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCampusAudDetails;


   PROCEDURE getFinanceAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      financeAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN financeAudDetails_cursor FOR
           SELECT ROWNUM, 'FINANCE' AS AUD_TAB, X.*
             FROM (SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AS AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          AUD.TABLE_PKEY1 AS INST_CODE,
                          I.INST_NAME,
                          '' AS CAMPUS_NAME,
                          DECODE (AUD.COLUMN_NAME,
                                  'BANK_HOUSE_NO_NAME', 'BANK_PROPERTY_ID',
                                  AUD.COLUMN_NAME)
                             AS COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM INST_AUD AUD, INST I
                    WHERE     AUD.TABLE_PKEY1 = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('ACCOUNT_NO',
                                  'BANK_ADDR_L1',
                                  'BANK_ADDR_L2',
                                  'BANK_ADDR_L3',
                                  'BANK_ADDR_L4',
                                  'BANK_HOUSE_NO_NAME',
                                  'BANK_NAME',
                                  'BANK_POST_CODE',
                                  'BANK_SORT_CODE',
                                  'PAYMENT_METHOD')
                          AND I.INST_CODE =
                                 NVL (UPPER (instCode_in), I.INST_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                   UNION
                   SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AS AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          C.INST_CODE,
                          I.INST_NAME,
                          C.NAME AS CAMPUS_NAME,
                          DECODE (AUD.COLUMN_NAME,
                                  'BANK_HOUSE_NO_NAME', 'BANK_PROPERTY_ID',
                                  AUD.COLUMN_NAME)
                             AS COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM CAMPUS_AUD AUD, CAMPUS C, INST I
                    WHERE     AUD.TABLE_PKEY1 = C.CAMPUS_ID
                          AND C.INST_CODE = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('ACCOUNT_NO',
                                  'BANK_ADDR_L1',
                                  'BANK_ADDR_L2',
                                  'BANK_ADDR_L3',
                                  'BANK_ADDR_L4',
                                  'BANK_HOUSE_NO_NAME',
                                  'BANK_NAME',
                                  'BANK_POST_CODE',
                                  'BANK_SORT_CODE',
                                  'PAYMENT_METHOD')
                          AND I.INST_CODE =
                                 NVL (UPPER (instCode_in), I.INST_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1) X
         ORDER BY TO_DATE (AUD_DATE, 'DD/MM/YYYY HH24:mi:ss') DESC;

      io_cursor := financeAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getFinanceAudDetails;


   PROCEDURE getCrseAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      crseAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN crseAudDetails_cursor FOR
         SELECT ROWNUM, 'CRSE' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          C.INST_CODE,
                          C.INST_NAME,
                          C.CRSE_CODE,
                          C.CRSE_NAME,
                          AUD.COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM CRSE_AUD AUD, CRSE C
                    WHERE     AUD.TABLE_PKEY1 = C.CRSE_ID
                          AND AUD.COLUMN_NAME IN
                                 ('CRSE_CODE',
                                  'CRSE_NAME',
                                  'FEES_CAMPUS',
                                  'HEI_CRSE_CODE',
                                  'MAINT_CAMPUS',
                                  'PAMS_COURSE',
                                  'QUAL_TYPE',
                                  'SCHEME_TYPE')
                          AND C.INST_CODE =
                                 NVL (UPPER (instCode_in), C.INST_CODE)
                          AND C.CRSE_CODE =
                                 NVL (UPPER (crseCode_in), C.CRSE_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC) X;

      io_cursor := crseAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCrseAudDetails;


   PROCEDURE getCrseSessionAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      crseSessionAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN crseSessionAudDetails_cursor FOR
         SELECT ROWNUM, 'CRSE_SESSION' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          I.INST_CODE,
                          I.INST_NAME,
                          C.CRSE_CODE,
                          C.CRSE_NAME,
                          AUD.SESSION_CODE,
                          AUD.COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM CRSE_SESSION_AUD AUD, CRSE C, INST I
                    WHERE     AUD.CRSE_ID = C.CRSE_ID
                          AND C.INST_CODE = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('MAX_DURATION', 'SESSION_CODE')
                          AND C.INST_CODE =
                                 NVL (UPPER (instCode_in), C.INST_CODE)
                          AND C.CRSE_CODE =
                                 NVL (UPPER (crseCode_in), C.CRSE_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC) X;

      io_cursor := crseSessionAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCrseSessionAudDetails;


   PROCEDURE getCrseYearAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      crseYearAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN crseYearAudDetails_cursor FOR
         SELECT ROWNUM, 'CRSE_YEAR' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          I.INST_CODE,
                          I.INST_NAME,
                          C.CRSE_CODE,
                          C.CRSE_NAME,
                          AUD.SESSION_CODE,
                          AUD.CRSE_YEAR_NO,
                          DECODE (AUD.COLUMN_NAME,
                                  'HEI_CRSE_CODE', 'SLC_CRSE_CODE',
                                  AUD.COLUMN_NAME)
                             AS COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM CRSE_YEAR_AUD AUD, INST I, CRSE C
                    WHERE     AUD.CRSE_ID = C.CRSE_ID
                          AND C.INST_CODE = I.INST_CODE
                          AND AUD.COLUMN_NAME IN
                                 ('CRSE_YEAR_NO',
                                  'CUTOFF_DATE',
                                  'CUTOFF_TYPE',
                                  'DEFAULT_TERMS',
                                  'EU_FLAG',
                                  'HEI_CRSE_CODE',
                                  'VAR_SANDWICH_TUITION_FEE_AMNT',
                                  'VAR_TUITION_FEE_AMNT')
                          AND C.INST_CODE =
                                 NVL (UPPER (instCode_in), C.INST_CODE)
                          AND C.CRSE_CODE =
                                 NVL (UPPER (crseCode_in), C.CRSE_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC) X;

      io_cursor := crseYearAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCrseYearAudDetails;


   PROCEDURE getCrseTermAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
      action_in       IN            VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      crseTermAudDetails_cursor   TERM_DATES_AUD_CURSOR;
   BEGIN
      OPEN crseTermAudDetails_cursor FOR
         SELECT ROWNUM, 'CRSE_TERM' AS AUD_TAB, X.*
           FROM (  SELECT TO_CHAR (AUD.AUD_DATE, 'DD/MM/YYYY HH24:mi:ss')
                             AUD_DATE,
                          TO_CHAR (AUD.AUD_DATE, 'YYYY/MM/DD HH24:mi:ss')
                             SORTABLE_AUD_DATE,
                          I.INST_CODE,
                          I.INST_NAME,
                          C.CRSE_CODE,
                          C.CRSE_NAME,
                          AUD.SESSION_CODE,
                          AUD.CRSE_YEAR_NO,
                          AUD.TABLE_PKEY2 TERM_NO,
                          AUD.COLUMN_NAME,
                          AUD.OLD,
                          AUD.NEW,
                          DECODE (AUD.ACTION,
                                  'I', 'INSERT',
                                  'D', 'DELETE',
                                  'U', 'UPDATE',
                                  AUD.ACTION)
                             AS ACTION,
                          AUD.USERNAME,
                          SGAS.PK_GENERAL_LOCKING.get_employee_name (
                             AUD.USERNAME)
                             AS EMPLOYEE_NAME
                     FROM CRSE_TERM_AUD AUD, CRSE C, INST I
                    WHERE     C.INST_CODE = I.INST_CODE
                          AND AUD.CRSE_ID = C.CRSE_ID
                          AND AUD.COLUMN_NAME IN
                                 ('DAYS', 'END_DATE', 'START_DATE', 'TERM_NO')
                          AND C.INST_CODE =
                                 NVL (UPPER (instCode_in), C.INST_CODE)
                          AND C.CRSE_CODE =
                                 NVL (UPPER (crseCode_in), C.CRSE_CODE)
                          AND AUD.USERNAME =
                                 NVL (UPPER (username_in), AUD.USERNAME)
                          AND AUD.ACTION = NVL (UPPER (action_in), AUD.ACTION)
                          AND AUD.AUD_DATE >=
                                 TO_DATE (
                                    NVL (dateFrom_in, getDefaultDateFrom ()),
                                    'DD/MM/YYYY')
                          AND AUD.AUD_DATE <=
                                   (TO_DATE (
                                       NVL (dateTo_in, getDefaultDateTo ()),
                                       'DD/MM/YYYY'))
                                 + 1
                 ORDER BY AUD.AUD_DATE DESC, CRSE_YEAR_NO, TERM_NO) X;

      io_cursor := crseTermAudDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCrseTermAudDetails;


   PROCEDURE validateInstCode (instCode_in      IN            VARCHAR2,
                               instName_out        OUT        VARCHAR2,
                               matchFound_out      OUT        VARCHAR2,
                               error_boolean       OUT NOCOPY VARCHAR2,
                               ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT I.INST_NAME
        INTO instName_out
        FROM INST I
       WHERE UPPER (I.INST_CODE) = UPPER (instCode_in);

      IF instName_out IS NOT NULL
      THEN
         matchFound_out := 'Y';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         matchFound_out := 'N';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END validateInstCode;


   PROCEDURE validateCrseCode (instCode_in      IN            VARCHAR2,
                               crseCode_in      IN            VARCHAR2,
                               crseName_out        OUT        VARCHAR2,
                               matchFound_out      OUT        VARCHAR2,
                               error_boolean       OUT NOCOPY VARCHAR2,
                               ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT C.CRSE_NAME
        INTO crseName_out
        FROM CRSE C
       WHERE     UPPER (C.INST_CODE) = UPPER (instCode_in)
             AND UPPER (C.CRSE_CODE) = UPPER (crseCode_in);

      IF crseName_out IS NOT NULL
      THEN
         matchFound_out := 'Y';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         matchFound_out := 'N';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END validateCrseCode;


   PROCEDURE validateUsername (username_in        IN            VARCHAR2,
                               employeeName_out      OUT        VARCHAR2,
                               matchFound_out        OUT        VARCHAR2,
                               error_boolean         OUT NOCOPY VARCHAR2,
                               ERROR_TEXT            OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT E.FORENAME || ' ' || E.SURNAME
        INTO employeeName_out
        FROM EMPLOYEE E
       WHERE E.USERNAME = UPPER (username_in);

      IF employeeName_out IS NOT NULL
      THEN
         matchFound_out := 'Y';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         matchFound_out := 'N';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END validateUsername;
END PK_STEPS_UI_TERM_DATES_AUDIT;
/
