ALTER TABLE SGAS.STUD
 ADD comp_jour   varchar2(1)     default 'N';

ALTER TABLE SGAS.STUD
 ADD nrs_cb   varchar2(1);     
 
ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_COMP_JOUR
 CHECK ( COMP_JOUR IN('Y', 'N')));

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_NRS_CB
 CHECK ( NRS_CB IN('Y', 'N', NULL)));

ALTER TABLE SGAS.STUD_SESSION
 ADD eu_flag   varchar2(1);
 
ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_EU_FLAG
 CHECK ( EU_FLAG IN('Y', 'N', NULL)));
 
ALTER TABLE SGAS.BENEFACTOR_INCOME
 ADD wtc_cb   varchar2(1);
 
ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT NN_BEI_WTC_CB
 CHECK ( WTC_CB IN('Y', 'N', NULL)));
 
ALTER TABLE SGAS.BENEFACTOR_INCOME
 ADD reason_no_income   varchar2(60);

ALTER TABLE SGAS.AWARD_INSTALMENT
 ADD adhoc_type   varchar2(1);

UPDATE CONFIG_DATA
SET CVAL = 2013
WHERE ITEM_NAME = 'CURRENT_SESSION';

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGLOAN', 'Loan', 'UG', 'STUDENT LOAN POST LOAN 16',
             'N', '213260', 'EHA', '10750100',
             '600', 'N', NULL, 'LOAN'
            );