-- STUD_AWARD_TYPE.sql
-- Description: Table holding all STUD AWARD TYPESs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      16.09.09    R Hunter (SAAS)         Initial Version.
-- 1.1      23.09.09    A.Bowman (SAAS)         Added the following columns 
--                                              DISAB_BASIC_MAX, DISAB_NON_MED_MAX, DISAB_EQUIP_MAX, DISAB_TRAV_MAX 
-- 1.2      05.10.09    A.Bowman (SAAS)         Amended data
-- 1.3      22.10.09    P.Hughes (SAAS)         Amended award_type_description and updated scheme_type NMSB to show_on_an_payments value to 'N'
-- 1.4      11.11.09    A.Bowman (SAAS)         Updated data insert with latest list of award types version 1.1
-- 1.5      11.11.09    A.Bowman (SAAS)         Removed the following columns
--                                              DISAB_BASIC_MAX, DISAB_NON_MED_MAX, DISAB_EQUIP_MAX, DISAB_TRAV_MAX
--                                              These columns will now be held in the STUD_RATES table
-- 1.6      19.02.10	P.Hughes (SAAS)		Update with new ISB Award Type
-- 1.7      28.07.10    P.Hughes (SAAS)         Updated award types to SAAS make payment = 'N'
-- 1.8      09.09.10    A.Bowman (SAAS)         Added new column type and appropriate values
-- 1.9      28.09.10    A.Bowman (SAAS)         Added new data and award type
-- 1.10     08.11.10    A.Bowman (SAAS)         Increased precision of STUD_AWARD_TYPE to VARCHAR2(20 BYTE)
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.stud_award_type
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.stud_award_type CASCADE CONSTRAINTS PURGE
/
--
-- STUD_AWARD_TYPE  (Table) 
--
CREATE TABLE sgas.stud_award_type (

stud_award_type_id      NUMBER(10) CONSTRAINT nn_stud_award_type_id NOT NULL,
stud_award_type         VARCHAR2(20 BYTE),
loan_non_loan_fee       VARCHAR2(15 BYTE),
scheme                  VARCHAR2(15 BYTE),
award_type_descript     VARCHAR2(100 BYTE) ,
show_on_an_payments     VARCHAR2(1) DEFAULT 'N',
cost_centre             VARCHAR2(15 BYTE),
programme               VARCHAR2(15 BYTE),
account_name            VARCHAR2(15 BYTE),
entity                  VARCHAR2(15 BYTE),
saas_make_payment       VARCHAR2(1) DEFAULT 'N',
comments                VARCHAR2(100 BYTE),
type                    VARCHAR2(4 BYTE),
last_updated_by         VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
last_updated_on         DATE                     DEFAULT SYSDATE               NOT NULL
)
/
CREATE UNIQUE INDEX stud_award_type_pk ON sgas.stud_award_type
(stud_award_type_id)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE sgas.stud_award_type ADD (
  CONSTRAINT stud_award_type_pk
 PRIMARY KEY
 (stud_award_type_id)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM stud_award_type
/
CREATE PUBLIC SYNONYM stud_award_type FOR sgas.stud_award_type
/
DROP SEQUENCE sgas.stud_award_type_id_seq
/
--
-- STUD_AWARD_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.stud_award_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER SGAS.trig_award_type_seq
   BEFORE INSERT
   ON SGAS.stud_award_type
   FOR EACH ROW
BEGIN
   SELECT stud_award_type_id_seq.NEXTVAL
     INTO :NEW.stud_award_type_id
     FROM DUAL;
END;                                                            

--
-- INSERT DATA
--

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UDMFL', 'Loan', 'UG', 'SCOT D MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNB', 'non-Loan', 'NMSB', 'STUDENT NURSES BURSARY',
             'Y', '242050', 'HAD', '60201355',
             '600', 'Y', NULL, 'BURS'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UDNL', 'Loan', 'UG', 'SCOT D NON-MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SOSB', 'non-Loan', 'UG', 'STUDENTS OUTSIDE SCOTLAND BURSARY',
             'Y', '213260', 'ECC', '60155935',
             '600', 'Y', NULL, 'BURS'
            );
INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNPE', 'non-Loan', 'NMSB', 'STUDENT NURSES PLACEMENT',
             'N', '242050', 'HAD', '60201360',
             '600', 'Y', NULL, 'TRAV'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UDHNL', 'Loan', 'UG',
             'SCOT D HEALTHCARE non-MEANS TESTED LOAN', 'N', '213260',
             'EHA', '60156500', '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UDHNFL', 'Loan', 'UG',
             'SCOT D HEALTHCARE non-MEANS TESTED FINAL YEAR LOAN', 'N',
             '213260', 'EHA', '60156500', '600', 'N',
             NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGOA', 'non-Loan', 'UG', 'LONE PARENT GRANT',
             'Y', '213260', 'ECC', '60155702',
             '600', 'Y', NULL, 'LPG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGDA', 'non-Loan', 'UG', 'UG DEPENDANTS GRANT',
             'Y', '213260', 'ECC', '60155704',
             '600', 'Y', NULL, 'DEPG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('LPCG', 'non-Loan', 'UG', 'LONE PARENT CHILDCARE GRANT',
             'Y', '213260', 'ECC', '60155703',
             '600', 'Y', NULL, 'LPCG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UCNL', 'Loan', 'UG', 'SCOT C non-MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );
INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UCNFL', 'Loan', 'UG',
             'SCOT C non-MEANS TESTED FINAL YEAR LOAN', 'N', '213260',
             'EHA', '60156500', '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('PSOA', 'non-Loan', 'PG', 'LONE PARENT GRANT',
             'Y', '213260', 'ECC', '60155702',
             '600', 'Y', NULL, 'LPG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UCMFL', 'Loan', 'UG', 'SCOT C MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGML', 'Loan', 'UG', 'MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGNL', 'Loan', 'UG', 'NON MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGMFL', 'Loan', 'UG', 'MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('PSDA', 'non-Loan', 'PG', 'DEPENDANTS GRANT',
             'Y', '213260', 'ECC', '60155704',
             '600', 'Y', NULL, 'DEPG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGTRAV', 'non-Loan', 'UG', 'UG TRAVEL EXPENSES',
             'N', '213260', 'ECC', '60155765',
             '600', 'Y', NULL, 'TRAV'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme,
             award_type_descript, show_on_an_payments, cost_centre,
             programme, account_name, entity, saas_make_payment, comments, type
            )
     VALUES ('UDNFL', 'Loan', 'UG',
             'SCOT D non MEANS TESTED FINAL YEAR LOAN', 'N', '213260',
             'EHA', '60156500', '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UDNXL', 'Loan', 'UG', 'CUBIE D EXTRA LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNIE', 'non-Loan', 'NMSB', 'INITIAL EXPENSES',
             'N', '242050', 'HAD', '60201355',
             '600', 'Y', NULL, 'BURS'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UDML', 'Loan', 'UG', 'SCOT D MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('YSB', 'non-Loan', 'UG', 'YOUNG STUDENTS BURSARY',
             'Y', '213260', 'ECC', '60155755',
             '600', 'Y', NULL, 'BURS'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNDA', 'non-Loan', 'NMSB', 'DEPENDANTS ALLOWANCE',
             'Y', '242050', 'HAD', '60201355',
             '600', 'Y', NULL, 'DEPG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UEMFL', 'Loan', 'UG', 'RUK E MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UENFL', 'Loan', 'UG', 'RUK E non MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UENL', 'Loan', 'UG', 'RUK E non MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGSMAH', 'non-Loan', 'UG', 'SMA FOR HEALTHCARE PROFESSIONALS',
             'Y', '213260', 'ECC', '60155760',
             '600', 'Y', NULL, 'SMA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UEML', 'Loan', 'UG', 'RUK E MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNSPA', 'non-Loan', 'NMSB', 'LONE PARENT ALLOWANCE',
             'N', '242050', 'HAD', '60201355',
             '600', 'Y', NULL, 'LPG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGDSA', 'non-Loan', 'UG', 'UG DISABLED STUDENTS GRANT',
             'N', '213260', 'ECC', '60155706',
             '600', 'Y', NULL, 'DSA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UCML', 'Loan', 'UG', 'SCOT C MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNBDSA', 'non-Loan', 'NMSB', 'SNB DSA',
             'N', '242050', 'HAD', '60201355',
             '600', 'Y', NULL, 'DSA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('PSSMA', 'non-Loan', 'PG', 'STANDARD MAINTENANCE ALLOWANCE',
             'Y', '213260', 'ECC', '60155760',
             '600', 'Y', NULL, 'SMA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme,
             award_type_descript, show_on_an_payments, cost_centre,
             programme, account_name, entity, saas_make_payment, comments, type
            )
     VALUES ('YSO', 'non-Loan', 'UG',
             'YOUNG STUDENT OUTSIDE SCOTLAND BURSARY', 'Y', '213260',
             'ECC', '60155752', '600', 'Y', NULL, 'BURS'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('PSDSA', 'non-Loan', 'PG', 'PG DISABLED STUDENTS GRANT',
             'N', '213260', 'ECC', '60155706',
             '600', 'Y', NULL, 'DSA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('UGNFL', 'Loan', 'UG', 'NON MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('ADHOC', 'non-Loan', 'UG', 'DISCRETIONARY PAYMENT',
             'N', '213260', 'ECC', '60155701',
             '600', 'Y', NULL, 'MAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNCAP', 'non-Loan', 'NMSB','NURSING AND MIDWIFERY STUDENT CHILDCARE ALLOWANCE FOR PARENTS',
             'Y', '242050', 'HAD', '60201355',
             '600', 'Y', NULL, 'LPCG'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('FEES', 'fee', 'N/A', 'TUITION FEE',
             'N', '213260', 'ECC', '60155770',
             '600', 'Y', NULL, 'FEE'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('TFEL', 'fee', 'N/A', 'TUITION FEE LOAN',
             'N', '213260', 'EHA', '10750101',
             '600', 'Y', NULL, 'FEE'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('DSATE', 'non-Loan', 'UG', 'DSA TRAVEL (New)',
             'N', '213260', 'ECC', '60155780',
             '600', 'Y', NULL, 'DSA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES (NULL, 'non-Loan', NULL, 'DSA ASSESSMENT CENTRE FEE',
             'N', '213260', 'ECC', '60155910',
             '600', 'Y', NULL, 'DSA'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNTE', 'non-Loan', 'NMSB', 'NMSB TRAVEL EXPENSES (New)',
             'N', '242050', 'HAD', '60201360',
             '600', 'Y', NULL, 'TRAV'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('RGML', 'Loan', 'UG', 'RUK G MEANS TESTED LOAN (New)',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('RGMFL', 'Loan', 'UG', 'RUK G MEANS TESTED FINAL YEAR LOAN (New)',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('RGNFL', 'Loan', 'UG', 'RUK G NON MEANS TESTED FINAL YEAR LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('RGNL', 'Loan', 'UG', 'RUK G NON MEANS TESTED LOAN',
             'N', '213260', 'EHA', '60156500',
             '600', 'N', NULL, 'LOAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('PGTRAV', 'non-Loan', 'PG', 'PG TRAVEL EXPENSES',
             'N', '213260', 'ECC', '60155765',
             '600', 'Y', NULL, 'TRAV'
            );


INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('SNADHOC', 'non-Loan', 'NMSB', 'NMSB AD-HOC',
             'N', '242050', 'HAD', '60201360',
             '600', 'Y', NULL, 'MAN'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            )
     VALUES ('ISB', 'non-Loan', 'UG', 'INDEPENDENT STUDENTS BURSARY',
             'Y', '213260', 'ECC', '60155755',
             '600', 'Y', NULL, 'BURS'
            );

INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            ) 
     VALUES ('PGDSATE', 'non-Loan', 'PG', 'POST GRADUATE DSA TRAVEL (NEW)', 
             'N', '213260', 'ECC', '60155780',
             '600', 'Y', NULL, 'DSA' 
            );
INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            ) 
     VALUES ('PAYMENTS', 'PAY', null, 'SAAS SUSPENSE', 
             'N', '213260', 'ECC', '12207580',
             '600', 'N', 'PAYMENT ACCOUNT INFORMATION', 'PAY' 
            );
INSERT INTO stud_award_type
            (stud_award_type, loan_non_loan_fee, scheme, award_type_descript,
             show_on_an_payments, cost_centre, programme, account_name,
             entity, saas_make_payment, comments, type
            ) 
     VALUES ('PAYMENTS', 'PAY', null, 'SAAS BANK INFO', 
             'N', '00001', 'ECC', '00000001',
             '600', 'N', 'PAYMENT ACCOUNT INFORMATION', 'PAY' 
            );         
COMMIT ;


