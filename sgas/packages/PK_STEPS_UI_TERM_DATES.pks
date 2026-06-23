CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_TERM_DATES
AS
   /******************************************************************************
      NAME:       PK_STEPS_UI_TERM_DATES
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      0.1       05/11/2018  Suresh          Created this package.
      0.2       07/02/2019  Ranj            Added getHEICrseCodeCount
      0.3       20/02/2019  Ranj            Added addCourseSession
      0.4       04/03/2019  Ranj            Added deleteInstTermDates
      0.5       06/03/2019  Ranj            Added saveCrseTermDates
      0.6       18/03/2019  Ranj            Added getStudInstTermsCount
      0.7       20/03/2019  Ranj            Added insertInstTermChange
      0.8       22/03/2019  Ranj            Added getInstTermDetails
      0.9       08/04/2019  Ranj            Added deleteCrseTermDates
   ******************************************************************************/
   TYPE TERM_DATES_CURSOR IS REF CURSOR;


   PROCEDURE getdd_campus_List (instCode_in     IN     VARCHAR2,
                                io_cursor          OUT TERM_DATES_CURSOR,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2);


   PROCEDURE getdd_inst_location (io_cursor       OUT TERM_DATES_CURSOR,
                                  error_boolean   OUT VARCHAR2,
                                  ERROR_TEXT      OUT VARCHAR2);


   PROCEDURE getdd_inst_type (io_cursor       OUT TERM_DATES_CURSOR,
                              error_boolean   OUT VARCHAR2,
                              ERROR_TEXT      OUT VARCHAR2);


   PROCEDURE getdd_subj_cat (io_cursor       OUT TERM_DATES_CURSOR,
                             error_boolean   OUT VARCHAR2,
                             ERROR_TEXT      OUT VARCHAR2);


   PROCEDURE getdd_Qual_List (io_cursor       OUT TERM_DATES_CURSOR,
                              error_boolean   OUT VARCHAR2,
                              ERROR_TEXT      OUT VARCHAR2);


   PROCEDURE getCampusDetails (
      campusCode_in   IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCourseDetails (instCode_in     IN            VARCHAR2,
                               crseCode_in     IN            VARCHAR2,
                               io_cursor       IN OUT        TERM_DATES_CURSOR,
                               error_boolean      OUT NOCOPY VARCHAR2,
                               ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCourseList (instCode_in     IN            VARCHAR2,
                            io_cursor       IN OUT        TERM_DATES_CURSOR,
                            error_boolean      OUT NOCOPY VARCHAR2,
                            ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCourseSessionList (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCrseTermDates (
      instCode_in      IN            VARCHAR2,
      sessionCode_in   IN            VARCHAR2,
      crseCode_in      IN            VARCHAR2,
      crseYearNo_in    IN            VARCHAR2,
      io_cursor        IN OUT        TERM_DATES_CURSOR,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2);


   PROCEDURE getCrseTermDetails (
      instCode_in               IN            VARCHAR2,
      sessionCode_in            IN            VARCHAR2,
      crseCode_in               IN            VARCHAR2,
      crseYearNo_in             IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      noOfCrseTermChanges_out      OUT        VARCHAR2,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2);


   PROCEDURE getHEICrseCodeCount (instCode_in          IN     VARCHAR2,
                                  heiCrseCode_in       IN     VARCHAR2,
                                  crseId_in            IN     VARCHAR2,
                                  numMatchesDiffInst      OUT VARCHAR2,
                                  numMatchesSameInst      OUT VARCHAR2,
                                  error_boolean           OUT VARCHAR2,
                                  ERROR_TEXT              OUT VARCHAR2);


   PROCEDURE getInstituteDetails (
      instCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getInstBankDetails (
      instCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getInstSessionList (
      instCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getInstTermDates (
      instCode_in              IN            VARCHAR2,
      sessionCode_in           IN            VARCHAR2,
      io_cursor                IN OUT        TERM_DATES_CURSOR,
      studInstTermsCount_out      OUT        VARCHAR2,
      error_boolean               OUT NOCOPY VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY VARCHAR2);


   PROCEDURE getInstTermDetails (
      instCode_in               IN            VARCHAR2,
      sessionCode_in            IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      noOfInstTermChanges_out      OUT        VARCHAR2,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2);


   PROCEDURE getLatestSessionCode (instCode_in       IN            VARCHAR2,
                                   crseCode_in       IN            VARCHAR2,
                                   sessioncCodeOut      OUT        VARCHAR2,
                                   error_boolean        OUT NOCOPY VARCHAR2,
                                   ERROR_TEXT           OUT NOCOPY VARCHAR2);


   PROCEDURE getSessionDetails (
      instCode_in                  IN            VARCHAR2,
      crseCode_in                  IN            VARCHAR2,
      sessionCode_in               IN            VARCHAR2,
      io_cursor                    IN OUT        TERM_DATES_CURSOR,
      max_duration                    OUT        VARCHAR2,
      studentsOnSessionCount_out      OUT        VARCHAR2,
      error_boolean                   OUT NOCOPY VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY VARCHAR2);


   PROCEDURE getStudCrseTermsCount (
      instCode_in              IN            VARCHAR2,
      crseCode_in              IN            VARCHAR2,
      sessionCode_in           IN            VARCHAR2,
      crseYearNo_in            IN            VARCHAR2,
      studCrseTermsCount_out      OUT        VARCHAR2,
      studentList_out             OUT        VARCHAR2,
      error_boolean               OUT NOCOPY VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY VARCHAR2);


   FUNCTION getStudentListForInst (instCode_in      IN VARCHAR2,
                                   sessionCode_in   IN VARCHAR2)
      RETURN VARCHAR2;


   PROCEDURE getStudInstTermsCount (
      instCode_in              IN            VARCHAR2,
      sessionCode_in           IN            VARCHAR2,
      studInstTermsCount_out      OUT        VARCHAR2,
      studentList_out             OUT        VARCHAR2,
      error_boolean               OUT NOCOPY VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY VARCHAR2);


   PROCEDURE addCourseSession (crse_code_in          IN            VARCHAR2,
                               inst_code_in          IN            VARCHAR2,
                               session_code_in       IN            VARCHAR2,
                               max_duration_in       IN            VARCHAR2,
                               user_in               IN            VARCHAR2,
                               crse_session_id_out      OUT NOCOPY VARCHAR2,
                               error_boolean            OUT NOCOPY VARCHAR2,
                               ERROR_TEXT               OUT NOCOPY VARCHAR2);


   PROCEDURE addInstitute (instCode_in          IN     VARCHAR2,
                           hei_inst_code_in     IN     VARCHAR2,
                           inst_name_in         IN     VARCHAR2,
                           post_code_in         IN     VARCHAR2,
                           house_no_in          IN     VARCHAR2,
                           address_l1_in        IN     VARCHAR2,
                           address_l2_in        IN     VARCHAR2,
                           address_l3_in        IN     VARCHAR2,
                           address_l4_in        IN     VARCHAR2,
                           telephone_no_in      IN     VARCHAR2,
                           inst_type_in         IN     VARCHAR2,
                           pay_method_in        IN     VARCHAR2,
                           location_in          IN     VARCHAR2,
                           pams_in              IN     VARCHAR2,
                           non_public_fund_in   IN     VARCHAR2,
                           user_in              IN     VARCHAR2,
                           dsa_only_in          IN     VARCHAR2,
                           error_boolean           OUT VARCHAR2,
                           ERROR_TEXT              OUT VARCHAR2);


   PROCEDURE addInstTermDates (instCode_in      IN     VARCHAR2,
                               sessioncode_in   IN     VARCHAR2,
                               termno_in        IN     VARCHAR2,
                               startdate_in     IN     VARCHAR2,
                               enddate_in       IN     VARCHAR2,
                               days_in          IN     VARCHAR2,
                               user_in          IN     VARCHAR2,
                               error_boolean       OUT VARCHAR2,
                               ERROR_TEXT          OUT VARCHAR2);


   PROCEDURE insertCampus (instCode_in        IN     VARCHAR2,
                           campusCode_in      IN     VARCHAR2,
                           campusName_in      IN     VARCHAR2,
                           post_code_in       IN     VARCHAR2,
                           house_no_in        IN     VARCHAR2,
                           address_l1_in      IN     VARCHAR2,
                           address_l2_in      IN     VARCHAR2,
                           address_l3_in      IN     VARCHAR2,
                           address_l4_in      IN     VARCHAR2,
                           pay_method_in      IN     VARCHAR2,
                           bankName_in        IN     VARCHAR2,
                           bankPostcode_in    IN     VARCHAR2,
                           bankHouseName_in   IN     VARCHAR2,
                           bankAddr1_in       IN     VARCHAR2,
                           bankAddr2_in       IN     VARCHAR2,
                           bankAddr3_in       IN     VARCHAR2,
                           bankAddr4_in       IN     VARCHAR2,
                           bankSortCode_in    IN     VARCHAR2,
                           bankAccNo_in       IN     VARCHAR2,
                           user_in            IN     VARCHAR2,
                           error_boolean         OUT VARCHAR2,
                           ERROR_TEXT            OUT VARCHAR2);


   PROCEDURE insertCourse (instCode_in      IN     VARCHAR2,
                           instName_in      IN     VARCHAR2,
                           crseCode_in      IN     VARCHAR2,
                           crseName_in      IN     VARCHAR2,
                           feesCampus_in    IN     VARCHAR2,
                           maintCampus_in   IN     VARCHAR2,
                           qualType_in      IN     VARCHAR2,
                           schemeType_in    IN     VARCHAR2,
                           pamsCourse_in    IN     VARCHAR2,
                           ga_in            IN     VARCHAR2,
                           heiCrseCode_in   IN     VARCHAR2,
                           user_in          IN     VARCHAR2,
                           dsa_only_in      IN     VARCHAR2,
                           error_boolean       OUT VARCHAR2,
                           ERROR_TEXT          OUT VARCHAR2);


   PROCEDURE insertCrseTermChange (
      hei_crse_code_in    IN            VARCHAR2,
      academic_year_in    IN            VARCHAR2,
      term_in             IN            VARCHAR2,
      new_term_start_in   IN            VARCHAR2,
      new_term_end_in     IN            VARCHAR2,
      new_fees_in         IN            VARCHAR2,
      old_term_start_in   IN            VARCHAR2,
      old_term_end_in     IN            VARCHAR2,
      old_fees_in         IN            VARCHAR2,
      change_type_in      IN            VARCHAR2,
      created_date_in     IN            VARCHAR2,
      created_by_in       IN            VARCHAR2,
      status_in           IN            VARCHAR2,
      status_by_in        IN            VARCHAR2,
      session_code_in     IN            VARCHAR2,
      hei_inst_code_in    IN            VARCHAR2,
      crse_id_in          IN            VARCHAR2,
      error_boolean          OUT NOCOPY VARCHAR2,
      ERROR_TEXT             OUT NOCOPY VARCHAR2);


   PROCEDURE insertInstTermChange (
      hei_inst_code_in        IN            VARCHAR2,
      inst_code_in            IN            VARCHAR2,
      session_code_in         IN            VARCHAR2,
      term_no_in              IN            VARCHAR2,
      new_start_date_in       IN            VARCHAR2,
      new_end_date_in         IN            VARCHAR2,
      new_days_in             IN            VARCHAR2,
      old_start_date_in       IN            VARCHAR2,
      old_end_date_in         IN            VARCHAR2,
      old_days_in             IN            VARCHAR2,
      change_type_in          IN            VARCHAR2,
      created_date_in         IN            VARCHAR2,
      created_by_in           IN            VARCHAR2,
      status_in               IN            VARCHAR2,
      status_by_in            IN            VARCHAR2,
      last_modified_date_in   IN            VARCHAR2,
      error_boolean              OUT NOCOPY VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY VARCHAR2);


   PROCEDURE saveCrseTermDates (crse_year_id_in   IN     VARCHAR2,
                                termno_in         IN     VARCHAR2,
                                startdate_in      IN     VARCHAR2,
                                enddate_in        IN     VARCHAR2,
                                days_in           IN     VARCHAR2,
                                user_in           IN     VARCHAR2,
                                error_boolean        OUT VARCHAR2,
                                ERROR_TEXT           OUT VARCHAR2);


   PROCEDURE updateCampus (instCode_in        IN     VARCHAR2,
                           campusCode_in      IN     VARCHAR2,
                           campusName_in      IN     VARCHAR2,
                           post_code_in       IN     VARCHAR2,
                           house_no_in        IN     VARCHAR2,
                           address_l1_in      IN     VARCHAR2,
                           address_l2_in      IN     VARCHAR2,
                           address_l3_in      IN     VARCHAR2,
                           address_l4_in      IN     VARCHAR2,
                           pay_method_in      IN     VARCHAR2,
                           bankName_in        IN     VARCHAR2,
                           bankPostcode_in    IN     VARCHAR2,
                           bankHouseName_in   IN     VARCHAR2,
                           bankAddr1_in       IN     VARCHAR2,
                           bankAddr2_in       IN     VARCHAR2,
                           bankAddr3_in       IN     VARCHAR2,
                           bankAddr4_in       IN     VARCHAR2,
                           bankSortCode_in    IN     VARCHAR2,
                           bankAccNo_in       IN     VARCHAR2,
                           user_in            IN     VARCHAR2,
                           error_boolean         OUT VARCHAR2,
                           ERROR_TEXT            OUT VARCHAR2);


   PROCEDURE updateCourse (instCode_in      IN     VARCHAR2,
                           heiCrseCode_in   IN     VARCHAR2,
                           crseName_in      IN     VARCHAR2,
                           schemeType_in    IN     VARCHAR2,
                           qualType_in      IN     VARCHAR2,
                           feesCampus_in    IN     VARCHAR2,
                           maintCampus_in   IN     VARCHAR2,
                           pamsCourse_in    IN     VARCHAR2,
                           ga_in            IN     VARCHAR2,
                           crseCode_in      IN     VARCHAR2,
                           user_in          IN     VARCHAR2,
                           dsa_only_in      IN     VARCHAR2,
                           error_boolean       OUT VARCHAR2,
                           ERROR_TEXT          OUT VARCHAR2);


   PROCEDURE updateCourseSession (crse_code_in      IN            VARCHAR2,
                                  inst_code_in      IN            VARCHAR2,
                                  session_code_in   IN            VARCHAR2,
                                  max_duration_in   IN            VARCHAR2,
                                  user_in           IN            VARCHAR2,
                                  error_boolean        OUT NOCOPY VARCHAR2,
                                  ERROR_TEXT           OUT NOCOPY VARCHAR2);


   PROCEDURE updateCrseYearDetails (instCode_in              IN     VARCHAR2,
                                    crseCode_in              IN     VARCHAR2,
                                    sessionCode_in           IN     VARCHAR2,
                                    max_duration_in          IN     VARCHAR2,
                                    crse_year_no_in          IN     VARCHAR2,
                                    study_abroad_in          IN     VARCHAR2,
                                    var_tui_fee_amount_in    IN     VARCHAR2,
                                    var_sand_fee_amount_in   IN     VARCHAR2,
                                    cutoff_type_in           IN     VARCHAR2,
                                    cutoff_date_in           IN     VARCHAR2,
                                    default_terms_in         IN     VARCHAR2,
                                    eu_flag_in               IN     VARCHAR2,
                                    eu_fee_loan_in           IN     VARCHAR2,
                                    hei_crse_code_in         IN     VARCHAR2,
                                    user_in                  IN     VARCHAR2,
                                    error_boolean               OUT VARCHAR2,
                                    ERROR_TEXT                  OUT VARCHAR2);


   PROCEDURE updateDefaultTermsFlag (
      crse_year_id_in         IN            VARCHAR2,
      default_terms_flag_in   IN            VARCHAR2,
      user_in                 IN            VARCHAR2,
      error_boolean              OUT NOCOPY VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY VARCHAR2);


   PROCEDURE updateInstitute (instCode_in          IN     VARCHAR2,
                              hei_inst_code_in     IN     VARCHAR2,
                              inst_name_in         IN     VARCHAR2,
                              post_code_in         IN     VARCHAR2,
                              house_no_in          IN     VARCHAR2,
                              address_l1_in        IN     VARCHAR2,
                              address_l2_in        IN     VARCHAR2,
                              address_l3_in        IN     VARCHAR2,
                              address_l4_in        IN     VARCHAR2,
                              telephone_no_in      IN     VARCHAR2,
                              inst_type_in         IN     VARCHAR2,
                              pay_method_in        IN     VARCHAR2,
                              location_in          IN     VARCHAR2,
                              pams_in              IN     VARCHAR2,
                              non_public_fund_in   IN     VARCHAR2,
                              user_in              IN     VARCHAR2,
                              dsa_only_in          IN     VARCHAR2,
                              error_boolean           OUT VARCHAR2,
                              ERROR_TEXT              OUT VARCHAR2);


   PROCEDURE updateInstituteBankDetails (instCode_in         IN     VARCHAR2,
                                         bankname_in         IN     VARCHAR2,
                                         bankpostcode_in     IN     VARCHAR2,
                                         house_no_in         IN     VARCHAR2,
                                         bankaddress_l1_in   IN     VARCHAR2,
                                         bankaddress_l2_in   IN     VARCHAR2,
                                         bankaddress_l3_in   IN     VARCHAR2,
                                         bankaddress_l4_in   IN     VARCHAR2,
                                         sortcode_in         IN     VARCHAR2,
                                         accountno_in        IN     VARCHAR2,
                                         user_in             IN     VARCHAR2,
                                         error_boolean          OUT VARCHAR2,
                                         ERROR_TEXT             OUT VARCHAR2);


   PROCEDURE updateInstTermDates (instCode_in      IN     VARCHAR2,
                                  sessioncode_in   IN     VARCHAR2,
                                  termno_in        IN     VARCHAR2,
                                  startdate_in     IN     VARCHAR2,
                                  enddate_in       IN     VARCHAR2,
                                  days_in          IN     VARCHAR2,
                                  user_in          IN     VARCHAR2,
                                  error_boolean       OUT VARCHAR2,
                                  ERROR_TEXT          OUT VARCHAR2);


   PROCEDURE deleteCrseSession (inst_code_in      IN     VARCHAR2,
                                crse_code_in      IN     VARCHAR2,
                                session_code_in   IN     VARCHAR2,
                                user_in           IN     VARCHAR2,
                                error_boolean        OUT VARCHAR2,
                                ERROR_TEXT           OUT VARCHAR2);


   PROCEDURE deleteCrseTermDates (crseYearId_in   IN     VARCHAR2,
                                  termno_in       IN     VARCHAR2,
                                  user_in         IN     VARCHAR2,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);


   PROCEDURE deleteCrseYearDetails (instCode_in       IN     VARCHAR2,
                                    crseCode_in       IN     VARCHAR2,
                                    sessionCode_in    IN     VARCHAR2,
                                    crse_year_no_in   IN     VARCHAR2,
                                    user_in           IN     VARCHAR2,
                                    error_boolean        OUT VARCHAR2,
                                    ERROR_TEXT           OUT VARCHAR2);


   PROCEDURE deleteInstTermDates (instCode_in      IN     VARCHAR2,
                                  sessionCode_in   IN     VARCHAR2,
                                  termno_in        IN     VARCHAR2,
                                  user_in          IN     VARCHAR2,
                                  error_boolean       OUT VARCHAR2,
                                  ERROR_TEXT          OUT VARCHAR2);


   PROCEDURE searchCourseList (instCode_in     IN            VARCHAR2,
                               crseCode_in     IN            VARCHAR2,
                               slcCode_in      IN            VARCHAR2,
                               crseName_in     IN            VARCHAR2,
                               io_cursor       IN OUT        TERM_DATES_CURSOR,
                               error_boolean      OUT NOCOPY VARCHAR2,
                               ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE searchInstitute (instName_in     IN            VARCHAR2,
                              instCode_in     IN            VARCHAR2,
                              io_cursor       IN OUT        TERM_DATES_CURSOR,
                              error_boolean      OUT NOCOPY VARCHAR2,
                              ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getDsaOnlyFlagCount (instCode_in     IN     VARCHAR2,
                                  crseId_in       IN     VARCHAR2,
                                  countResult        OUT VARCHAR2,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);
END PK_STEPS_UI_TERM_DATES;
/
