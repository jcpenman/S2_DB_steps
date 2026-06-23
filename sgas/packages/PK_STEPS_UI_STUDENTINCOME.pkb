CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_studentincome
AS
   /******************************************************************************
      NAME:       pk_steps_ui_studentincome
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/12/2012  PADDY GRACE      Created this package.
      1.1        10/12/2014  EWAN WATSON      Added care_leaver COS 2015
      1.2        23/11/2017  Suresh Sharada   Added CESB flags procedure SFD - 2
      1.3         30/11/2017  RANJ BENNING      Added estranged flag - SFD 2
   ******************************************************************************/
   PROCEDURE getstudentincome (
      stud_session_id_in   IN            VARCHAR2,
      io_cursor            IN OUT        stud_income_cursor,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      si_cursor   stud_income_cursor;
   BEGIN
      OPEN si_cursor FOR
         SELECT si.stud_income_id,
                si.income_type,
                si.amount,
                si.last_updated_by,
                TO_CHAR (si.last_updated_on, 'DD/MM/YYYY')
           FROM stud_income si
          WHERE si.stud_session_id = stud_session_id_in;

      io_cursor := si_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudentincome;

   PROCEDURE setstudentincome (stud_income_id_in   IN            VARCHAR2,
                               income_type_in      IN            VARCHAR2,
                               amount_in           IN            VARCHAR2,
                               user_in             IN            VARCHAR2,
                               error_boolean          OUT NOCOPY VARCHAR2,
                               ERROR_TEXT             OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      UPDATE stud_income si
         SET si.income_type = income_type_in,
             si.amount = amount_in,
             si.last_updated_by = UPPER (user_in),
             si.last_updated_on = SYSDATE
       WHERE si.stud_income_id = stud_income_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setstudentincome;

   PROCEDURE insertstudentincome (
      stud_session_id_in   IN            VARCHAR2,
      income_type_in       IN            VARCHAR2,
      amount_in            IN            VARCHAR2,
      user_in              IN            VARCHAR2,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      INSERT INTO stud_income si (si.stud_session_id,
                                  si.income_type,
                                  si.amount,
                                  si.last_updated_by,
                                  si.last_updated_on)
           VALUES (stud_session_id_in,
                   income_type_in,
                   amount_in,
                   user_in,
                   SYSDATE);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertstudentincome;

   PROCEDURE deletestudentincome (stud_income_id_in   IN            VARCHAR2,
                                  user_in             IN            VARCHAR2,
                                  error_boolean          OUT NOCOPY VARCHAR2,
                                  ERROR_TEXT             OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      UPDATE stud_income si
         SET si.last_updated_by = UPPER (user_in)
       WHERE si.stud_income_id = stud_income_id_in;

      DELETE FROM stud_income si
            WHERE si.stud_income_id = stud_income_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deletestudentincome;

   PROCEDURE getincomeflags (
      stud_session_id_in         IN            VARCHAR2,
      stud_hei_bursary_consent      OUT NOCOPY VARCHAR2,
      parent_contrib_exempt         OUT NOCOPY VARCHAR2,
      pay_ysb                       OUT NOCOPY VARCHAR2,
      pay_isb                       OUT NOCOPY VARCHAR2,
      care_leaver                   OUT NOCOPY VARCHAR2,
      estranged                     OUT NOCOPY VARCHAR2,
      estranged_evidence            OUT NOCOPY VARCHAR2,    
      error_boolean                 OUT NOCOPY VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      SELECT NVL (ss.stud_hei_bursary_consent, 'N')
                AS stud_hei_bursary_consent,
             NVL (scy.parent_contrib_exempt, 'N') AS parent_contrib_exempt,
             NVL (scy.pay_ysb, 'N') AS pay_ysb,
             NVL (scy.pay_isb, 'N') AS pay_isb,
             NVL (ss.care_leaver, 'N') AS care_leaver,
             NVL (s.estranged, 'N') AS estranged,
             NVL (s.estranged_evidence, 'N') AS estranged_evidence
        INTO stud_hei_bursary_consent,
             parent_contrib_exempt,
             pay_ysb,
             pay_isb,
             care_leaver,
             estranged,
             estranged_evidence
        FROM stud_session ss, stud_crse_year scy, stud s
       WHERE     scy.stud_session_id = ss.stud_session_id
             AND scy.latest_crse_ind = 'Y'
             AND ss.stud_session_id = stud_session_id_in
             AND s.stud_ref_no = ss.stud_ref_no;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getincomeflags;

   PROCEDURE setincomeflags (
      stud_session_id_in            IN            VARCHAR2,
      stud_hei_bursary_consent_in   IN            VARCHAR2,
      parent_contrib_exempt_in      IN            VARCHAR2,
      pay_ysb_in                    IN            VARCHAR2,
      pay_isb_in                    IN            VARCHAR2,
      care_leaver_in                IN            VARCHAR2,
      user_in                       IN            VARCHAR2,
      stud_ref_no_in                IN            VARCHAR2,
      estranged_in                  IN            VARCHAR2,
      estranged_evidence_in         IN            VARCHAR2,
      error_boolean                    OUT NOCOPY VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      UPDATE stud_crse_year scy
         SET scy.parent_contrib_exempt = UPPER (parent_contrib_exempt_in),
             scy.pay_ysb = UPPER (pay_ysb_in),
             scy.pay_isb = UPPER (pay_isb_in),
             scy.last_updated_by = UPPER (user_in),
             scy.last_updated_on = SYSDATE
       WHERE scy.stud_session_id = stud_session_id_in;

      UPDATE stud_session ss
         SET ss.stud_hei_bursary_consent = stud_hei_bursary_consent_in,
             ss.care_leaver = UPPER (care_leaver_in),
             ss.last_updated_by = UPPER (user_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = stud_session_id_in;
       
      UPDATE stud s
         SET s.estranged = UPPER (estranged_in),
             s.estranged_evidence = UPPER (estranged_evidence_in)
       WHERE s.stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setincomeflags;
   
PROCEDURE getCESBflags (stud_ref_no_in           IN            VARCHAR2,
                        CARE_EXP_FOSTER             OUT NOCOPY VARCHAR2,
                        CARE_EXP_RES                OUT NOCOPY VARCHAR2,
                        CARE_EXP_KINSHIP_LA         OUT NOCOPY VARCHAR2,
                        CARE_EXP_KINSHIP_NO_LA      OUT NOCOPY VARCHAR2,
                        CARE_EXP_HOME               OUT NOCOPY VARCHAR2,
                        CARE_EXP_OTHER              OUT NOCOPY VARCHAR2,
                        CARE_EXP_OTHER_DETAILS      OUT NOCOPY VARCHAR2,
                        CARE_EXP_START_AGE          OUT NOCOPY VARCHAR2,
                        CARE_EXP_END_AGE            OUT NOCOPY VARCHAR2,
                        CARE_EXP_EVID_RECVD         OUT NOCOPY VARCHAR2,
                        error_boolean               OUT NOCOPY VARCHAR2,
                        ERROR_TEXT                  OUT NOCOPY VARCHAR2)
IS
    row_count varchar2(1);
    
    
BEGIN
    select COUNT(*) into row_count from cesb_flags where stud_ref_no=stud_ref_no_in;

    if (row_count='1') then
    begin
          SELECT NVL (CF.CARE_EXP_FOSTER, 'N') AS CARE_EXP_FOSTER,
          NVL (CF.CARE_EXP_RES, 'N') AS CARE_EXP_RES,
          NVL (CF.CARE_EXP_KINSHIP_LA, 'N') AS CARE_EXP_KINSHIP_LA,
          NVL (CF.CARE_EXP_KINSHIP_NO_LA, 'N') AS CARE_EXP_KINSHIP_NO_LA,
          NVL (CF.CARE_EXP_HOME, 'N') AS CARE_EXP_HOME,
          NVL (CF.CARE_EXP_OTHER, 'N') AS CARE_EXP_OTHER,
          NVL (CF.CARE_EXP_OTHER_DETAILS, '') AS CARE_EXP_OTHER_DETAILS,
          NVL (CF.CARE_EXP_START_AGE, '') AS CARE_EXP_START_AGE,
          NVL (CF.CARE_EXP_END_AGE, '') AS CARE_EXP_END_AGE
          --NVL (S.CESB_EVI_RECVD, 'N') AS CARE_EXP_EVID_RECVD
          into
          CARE_EXP_FOSTER, CARE_EXP_RES, CARE_EXP_KINSHIP_LA, CARE_EXP_KINSHIP_NO_LA, 
          CARE_EXP_HOME, CARE_EXP_OTHER, CARE_EXP_OTHER_DETAILS, CARE_EXP_START_AGE,
          CARE_EXP_END_AGE
          --, CARE_EXP_EVID_RECVD
          
     FROM CESB_FLAGS CF
     --, STUD S
    WHERE 
    CF.STUD_REF_NO = STUD_REF_NO_IN;
    -- AND S.STUD_REF_NO =CF.STUD_REF_NO;
    --S.CESB_EVI_RECVD='Y' AND S.STUD_REF_NO =CF.STUD_REF_NO
    end;
    
    else
    
     CARE_EXP_FOSTER := 'N';
     CARE_EXP_RES :='N';
     CARE_EXP_KINSHIP_LA:= 'N';
     CARE_EXP_KINSHIP_NO_LA :='N';
     CARE_EXP_HOME:='N';
     CARE_EXP_OTHER := 'N';
     CARE_EXP_OTHER_DETAILS :='';
     CARE_EXP_START_AGE :='';
     CARE_EXP_END_AGE :='';
     --CARE_EXP_EVID_RECVD :='N'; 
    
    end if;
    
    SELECT NVL(S.CARE_EXP_EVIDENCE_RECVD, 'N') INTO CARE_EXP_EVID_RECVD FROM STUD S WHERE S.STUD_REF_NO= stud_ref_no_in;
    
   error_boolean := 'false';
   ERROR_TEXT := 'none';
EXCEPTION
   WHEN OTHERS
   THEN
      error_boolean := 'true';
      ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
END getCESBflags;


PROCEDURE setCESBflags (stud_ref_no_in              IN            VARCHAR2,
                        CARE_EXP_FOSTER_in          IN            VARCHAR2,
                        CARE_EXP_RES_in             IN            VARCHAR2,
                        CARE_EXP_KINSHIP_LA_in      IN            VARCHAR2,
                        CARE_EXP_KINSHIP_NO_LA_in   IN            VARCHAR2,
                        CARE_EXP_HOME_in            IN            VARCHAR2,
                        CARE_EXP_OTHER_in           IN            VARCHAR2,
                        CARE_EXP_OTHER_DETAILS_in   IN            VARCHAR2,
                        CARE_EXP_START_AGE_in       IN            VARCHAR2,
                        CARE_EXP_END_AGE_in         IN            VARCHAR2,
                        CARE_EXP_EVID_RECVD_in      IN            VARCHAR2,
                        user_in                     IN            VARCHAR2,
                        error_boolean                  OUT NOCOPY VARCHAR2,
                        ERROR_TEXT                     OUT NOCOPY VARCHAR2)
IS
        row_count varchar2(1);    
BEGIN
        
        select COUNT(*) into row_count from cesb_flags where stud_ref_no=stud_ref_no_in;

    if (row_count='1') then
    begin
           UPDATE CESB_FLAGS CF
              SET CF.CARE_EXP_FOSTER = CARE_EXP_FOSTER_in,
                  CF.CARE_EXP_RES = CARE_EXP_RES_in,
                  CF.CARE_EXP_KINSHIP_LA = CARE_EXP_KINSHIP_LA_in,
                  CF.CARE_EXP_KINSHIP_NO_LA = CARE_EXP_KINSHIP_NO_LA_in,
                  CF.CARE_EXP_HOME = CARE_EXP_HOME_in,
                  CF.CARE_EXP_OTHER = CARE_EXP_OTHER_in,
                  CF.CARE_EXP_OTHER_DETAILS = CARE_EXP_OTHER_DETAILS_in,
                  CF.CARE_EXP_START_AGE = CARE_EXP_START_AGE_in,
                  CF.CARE_EXP_END_AGE = CARE_EXP_END_AGE_in,
                  CF.LAST_UPDATED_BY = user_in
            WHERE CF.STUD_REF_NO = STUD_REF_NO_in;
   end;
   else
       insert into cesb_flags values(stud_ref_no_in, CARE_EXP_FOSTER_in, CARE_EXP_RES_in, CARE_EXP_KINSHIP_LA_in, CARE_EXP_KINSHIP_NO_LA_in,
                             CARE_EXP_HOME_in, CARE_EXP_OTHER_in, CARE_EXP_OTHER_DETAILS_in, CARE_EXP_START_AGE_in, CARE_EXP_END_AGE_in, user_in); 
   end if;
   
   UPDATE stud s
      SET s.CARE_EXP_EVIDENCE_RECVD = CARE_EXP_EVID_RECVD_in,
          S.LAST_UPDATED_BY = user_in,
          S.LAST_UPDATED_ON = SYSDATE
    WHERE s.STUD_REF_NO = stud_ref_no_in;

   error_boolean := 'false';
   ERROR_TEXT := 'none';
EXCEPTION
   WHEN OTHERS
   THEN
      error_boolean := 'true';
      ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
END setCESBflags;

   
END pk_steps_ui_studentincome;
/
