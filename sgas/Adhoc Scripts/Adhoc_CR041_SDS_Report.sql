DROP VIEW SGAS.SDS_REPORT_VIEW;

/* Formatted on 06/07/2015 09:40:47 (QP5 v5.215.12089.38647) */
CREATE OR REPLACE FORCE VIEW SGAS.SDS_REPORT_VIEW
(
   "STUDENT REFERENCE NO",
   "FIRST NAMES",
   SURNAME,
   "DATE OF BIRTH",
   "HOUSE NUMBER OR NAME",
   "ADDRESS LINE 1",
   "ADDRESS LINE 2",
   "ADDRESS LINE 3",
   "ADDRESS LINE 4",
   POSTCODE,
   "INSTITUTION CODE",
   "INSTITUTION NAME",
   "COURSE NAME",
   "QUALIFICATION TYPE",
   "FIRST TERM START DATE",
   "APPLICATION STATUS",
   "YEAR OF COURSE",
   "SCOTTISH CANDIDATE NO",
   GENDER,
   "ENROLMENT STATUS",
   "GRADUATION SESSION",
   "WITHDRAWAL DATE",
   "SESSION CODE"
)
AS
   (SELECT S.STUD_REF_NO,
           S.FORENAMES,
           S.SURNAME,
           S.DOB,
           SHA.HOUSE_NO_NAME,
           SHA.ADDR_L1,
           SHA.ADDR_L2,
           SHA.ADDR_L3,
           SHA.ADDR_L4,
           SHA.POST_CODE,
           SCY.INST_CODE,
           SCY.INST_NAME,
           SCY.CRSE_NAME,
           C.QUAL_TYPE,
           RULES_PROC_RECALC.getStartDateTerm (SCY.STUD_CRSE_YEAR_ID, 1),
           SCY.APPLICATION_STATUS,
           SCY.CRSE_YEAR_NO,
           S.SCOTTISH_CAND,
           S.SEX,
           AD.ENROL_CONFIRMED,
           SCY.GRAD_SESSION,
           SCY.WITHDRAW_DATE,
           SCY.SESSION_CODE
      FROM STUD S,
           STUD_HOME_ADDR SHA,
           STUD_CRSE_YEAR SCY,
           ATTENDANCE_DATA AD,
           CRSE C
     WHERE     S.STUD_REF_NO = SHA.STUD_REF_NO -- join STUD and STUD_HOME_ADDR
           AND SHA.END_DATE IS NULL -- most recent address (student may have moved in current year)
           AND S.STUD_REF_NO = SCY.STUD_REF_NO -- join STUD and STUD_CRSE_YEAR
           AND SCY.STUD_CRSE_YEAR_ID = AD.STUD_CRSE_YEAR_ID -- join STUD_CRSE_YEAR and ATTENDANCE_DATA
           AND C.CRSE_ID(+) = SCY.CRSE_ID      -- join CRSE and STUD_CRSE_YEAR
           AND SCY.SESSION_CODE = (SELECT CVAL
                                     FROM CONFIG_DATA
                                    WHERE ITEM_NAME = 'CURRENT_SESSION') -- student applied for funding in current session
           AND SCY.LATEST_CRSE_IND = 'Y' -- latest course year indicator is 'Y'
           AND SCY.APPLICATION_STATUS != 'R'
           AND (MONTHS_BETWEEN((SYSDATE),S.DOB )/12) >= 15
           AND (MONTHS_BETWEEN((SYSDATE),S.DOB )/12) < 25);