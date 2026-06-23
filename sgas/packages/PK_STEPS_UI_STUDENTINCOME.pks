CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_studentincome
AS
   /******************************************************************************
      NAME:       pk_steps_ui_studentincome
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/12/2012  PADDY GRACE      Created this package.
      1.1        10/12/2014  EWAN WATSON      Added care_leaver - COS 2015
      1.2       23/11/2017  Suresh sharada    Added CESB flags procedure SFD - 2
      1.3        30/11/2017  RANJ BENNING      Added estranged flag - SFD 2
   ******************************************************************************/
   TYPE stud_income_cursor IS REF CURSOR;

   PROCEDURE getstudentincome (
      stud_session_id_in   IN            VARCHAR2,
      io_cursor            IN OUT        stud_income_cursor,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2);

   PROCEDURE setstudentincome (stud_income_id_in   IN            VARCHAR2,
                               income_type_in      IN            VARCHAR2,
                               amount_in           IN            VARCHAR2,
                               user_in             IN            VARCHAR2,
                               error_boolean          OUT NOCOPY VARCHAR2,
                               ERROR_TEXT             OUT NOCOPY VARCHAR2);

   PROCEDURE insertstudentincome (
      stud_session_id_in   IN            VARCHAR2,
      income_type_in       IN            VARCHAR2,
      amount_in            IN            VARCHAR2,
      user_in              IN            VARCHAR2,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2);

   PROCEDURE deletestudentincome (stud_income_id_in   IN            VARCHAR2,
                                  user_in             IN            VARCHAR2,
                                  error_boolean          OUT NOCOPY VARCHAR2,
                                  ERROR_TEXT             OUT NOCOPY VARCHAR2);

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
      ERROR_TEXT                    OUT NOCOPY VARCHAR2);

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
      ERROR_TEXT                       OUT NOCOPY VARCHAR2);
      
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
                        ERROR_TEXT                  OUT NOCOPY VARCHAR2);
                        
 PROCEDURE setCESBflags (stud_ref_no_in             IN            VARCHAR2,
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
                        error_boolean               OUT NOCOPY VARCHAR2,
                        ERROR_TEXT                  OUT NOCOPY VARCHAR2);
      
END pk_steps_ui_studentincome;
/