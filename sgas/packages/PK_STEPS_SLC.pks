CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_SLC IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- %Z%%Y% %M% %G% %U% %I%%Z%
--
-- DESCRIPTION
-- ===========
/* CHANGE HISTORY 
Version Date         Author         Change 
1.0    04/05/2011   A.Bowman       Package to select STEPS data in the production of SLC 1 and SLC 2 files*/
TYPE stud_loan_cursor IS REF CURSOR;
TYPE file_one_cursor IS REF CURSOR;
TYPE file_two_cursor IS REF CURSOR;
TYPE transaction_cursor IS REF CURSOR;
TYPE file_feeLoan_cursor IS REF CURSOR;
TYPE feeLoanfile_one_cursor IS REF CURSOR;
TYPE file_one_cursor_hebbs IS REF CURSOR;

--PROCEDURE fetch_slc_file1(p_stud_loan OUT stud_loan_cursor);
FUNCTION getFeeLoanIntAccrual (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN CHAR;
FUNCTION getFeeLoanPayment (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
FUNCTION getFeeLoanAmount (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
FUNCTION getFeeSLCInclude (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN CHAR;
FUNCTION getLivingCostLoanAvailable (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
FUNCTION getMaxStudCrseYearLoan (p_stud_ref_no IN NUMBER) RETURN NUMBER;
FUNCTION getCrseEndDate(p_stud_crse_year_id IN NUMBER) RETURN DATE;
FUNCTION getHEIInstName(p_HEI_INST_CODE IN CHAR) RETURN CHAR;
FUNCTION getHEICrseName(p_HEI_CRSE_CODE IN CHAR, p_HEI_INST_CODE IN CHAR) RETURN CHAR;
FUNCTION getBenefactor1TotalIncome(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
FUNCTION getBenefactor2TotalIncome(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
FUNCTION getHouseHoldResidential(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
FUNCTION getSOSBTotal(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;

FUNCTION getNetAmountClaimed (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;

PROCEDURE get_slc_file1(p_file_one OUT file_one_cursor);
PROCEDURE get_slc_file2(p_file_two OUT file_two_cursor);
PROCEDURE updateFeeLoanTransaction(p_transaction OUT transaction_cursor);
PROCEDURE get_slc_filefeeLoan(p_file_feeLoan OUT file_feeLoan_cursor);
PROCEDURE get_slc_fileFL1(p_feeLoanfile_one OUT feeLoanfile_one_cursor);
PROCEDURE update_stud_crse_yr_slc_status (p_stud_crse_yr_id NUMBER);
PROCEDURE updatedatabaseAmounts;
PROCEDURE get_slc_file1_hebbs(p_file_one_hebbs OUT file_one_cursor_hebbs);


END PK_STEPS_SLC;
/
