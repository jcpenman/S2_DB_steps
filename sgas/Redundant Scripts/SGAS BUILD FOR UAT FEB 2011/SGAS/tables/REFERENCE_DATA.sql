-- 
-- reference_data.sql - create table script.
--
-- DESCRIPTION
-- The reference_data table holds general static reference look-up data for steps.
-- The model is very generalised with high level domains, types and actual data modelled, but not specific
-- instances. E.g. disability types will be reference data falling into the DSA domain. They are not modelled in 
-- a separate DSA_% table.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 001      03.02.10    A.Bowman (SAAS)              Added data insert script
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/REFERENCE_DATA.sql $
-- $Author: $
-- $Date: 2010-02-03 11:35:48 +0000 (Wed, 03 Feb 2010) $
-- $Revision: 4733 $

DROP TABLE SGAS.reference_data
CASCADE CONSTRAINTS
/

CREATE TABLE SGAS.reference_data
(
 id             NUMBER(10),  -- Sys id. 
 ref_type_id    NUMBER(10),  -- foreign key to the category type 
 short_name     VARCHAR2(100),
 description    VARCHAR2(4000)
)
/
--
-- Column comments
-- 
COMMENT ON COLUMN SGAS.reference_data.id IS 'System reference: Reference Type unique ID'
/
COMMENT ON COLUMN SGAS.reference_data.ref_type_id IS 'System reference: Link to reference type.'
/
COMMENT ON COLUMN SGAS.reference_data.short_name IS 'Reference type name.'
/
COMMENT ON COLUMN SGAS.reference_data.description IS 'Free text description of the data.'
/

--
-- P_CAT  (Index) 
--
CREATE UNIQUE INDEX p_rd ON SGAS.reference_data
(id)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

ALTER TABLE SGAS.reference_data ADD (
  CONSTRAINT p_rd
 PRIMARY KEY
 (id)
    USING INDEX 
)
/

ALTER TABLE SGAS.reference_data
ADD CONSTRAINT F_rd1
  FOREIGN KEY (ref_type_id)
  REFERENCES reference_types (id)
/

--- SET DEFINE OFF;

Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1000, 15, 'SAS', NULL);
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1001, 15, 'SNB', NULL);
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1002, 15, 'SSS', NULL);
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1003, 15, 'PSAS', NULL);
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1004, 16, 'UNCONDITIONAL OFFER', 'UNCONDITIONAL OFFER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1005, 16, 'TRANSFER CERTIFICATE', 'CERTIFICATE OF TRANSFER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1006, 16, 'PARCON EXEMPT', 'PROOF OF EXEMPTION FROM PARCON');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1007, 16, 'MSA ELIOGIBILITY', 'EVIDENCE OF ELIGIBILITY FROM MSA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1008, 16, 'OPTIONAL ALLOWANCE', 'EVIDENCE IN SUPPORT OF OPTIONAL ALLOWANCE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1009, 16, 'MARRIAGE CERTIFICATE', 'MARRIAGE CERTIFICATE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1010, 16, 'HOME OWNERSHIP', 'EVIDENCE OF TENANCY/HOME OWNERSHIP');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1011, 16, 'DIVORCE DECREE', 'DIVORCE DECREE OR SOLICITOR`S LETTER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1012, 16, 'PARENTAL OR SPOUSE INCOME', 'EVIDENCE OF PARENTAL OR SPOUSE INCOME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1013, 16, 'ALLOWABLE DEDUCTIONS', 'EVIDENCE OF ALLOWABLE DEDUCTIONS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1014, 16, 'BIRTH CERTIFICATE', 'BIRTH CERTIFICATE OF DEPENDANT CHILDREN (BENEFACTOR`S OR STUDENT`S)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1015, 16, 'STUDENT INCOME', 'EVIDENCE OF STUDENT INCOME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1016, 16, 'DEPENDANT`S INCOME', 'EVIDENCE OF DEPENDANT`S INCOME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1017, 16, 'SPONSORSHIP', 'EVIDENCE OF SPONSORSHIP');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1018, 16, 'DSA EVIDENCE', 'EVIDENCE JUSTIFYING DSA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1019, 17, 'E', 'All Support');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1020, 17, 'A', 'Fees & Non-means tested loan (claimed)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1021, 17, 'B', 'Fees & Non-means tested loan (assessed)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1022, 17, 'C', 'Fees & Non-means tested loan (system)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1023, 17, 'D', 'Fees & Non-means tested loan (caseworker)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1024, 18, 'B', 'BACS payment');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1025, 18, 'C', 'Cheque');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1026, 19, 'ENGLISH', 'ENGLISH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1027, 19, 'HISTORY', 'HISTORY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1028, 19, 'LAW', 'LAW');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1029, 19, 'PHILOSOPHY', 'PHILOSOPHY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1030, 19, 'LITERATURE', 'LITERATURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1031, 19, 'LINGUISTICS', 'LINGUISTICS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1032, 19, 'FILM AND THEATRE', 'FILM AND THEATRE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1033, 19, 'ART HISTORY', 'ART HISTORY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1034, 19, 'ARCHAEOLOGY', 'ARCHAEOLOGY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1035, 19, 'CLASSICS', 'CLASSICS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1036, 19, 'THEOLOGY', 'THEOLOGY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1037, 19, 'MUSIC', 'MUSIC');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1038, 19, 'PUBLISHING STUDIES', 'PUBLISHING STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1039, 19, 'FRENCH', 'FRENCH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1040, 19, 'GERMAN', 'GERMAN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1041, 19, 'ITALIAN', 'ITALIAN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1042, 19, 'HISPANIC STUDIES', 'HISPANIC STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1043, 19, 'JAPANESE', 'JAPANESE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1044, 19, 'EUROPEAN STUDIES', 'EUROPEAN STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1045, 19, 'ART AND DESIGN', 'ART AND DESIGN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1046, 19, 'CELTIC/IRISH', 'CELTIC/IRISH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1047, 19, 'RUSSIAN', 'RUSSIAN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1048, 19, 'SCOTTISH STUDIES', 'SCOTTISH STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1049, 19, 'HUMAN RIGHTS', 'HUMAN RIGHTS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1050, 19, 'ORIENTAL STUDIES', 'ORIENTAL STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1051, 19, 'ARCHITECTURE', 'ARCHITECTURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1052, 19, 'SLAVONIC', 'SLAVONIC');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1053, 19, 'SPANISH', 'SPANISH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1054, 19, 'AGRICULTURE', 'AGRICULTURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1055, 19, 'ALLIED TO MEDICINE', 'ALLIED TO MEDICINE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1056, 19, 'ARCHITECTURE,BUILDING AND PLANNING', 'ARCHITECTURE,BUILDING AND PLANNING');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1057, 19, 'BIOLOGICAL SCIENCES', 'BIOLOGICAL SCIENCES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1058, 19, 'BUSINESS AND ADMINISTRATIVE STUDIES', 'BUSINESS AND ADMINISTRATIVE STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1059, 19, 'CATERING', 'CATERING');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1060, 19, 'COMBINED OR GENERAL', 'COMBINED OR GENERAL');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1061, 19, 'CREATIVE ARTS', 'CREATIVE ARTS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1062, 19, 'DENTISTRY', 'DENTISTRY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1063, 19, 'EDUCATION', 'EDUCATION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1064, 19, 'ENGINEERING AND TECHNOLOGY', 'ENGINEERING AND TECHNOLOGY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1065, 19, 'HUMANITIES', 'HUMANITIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1066, 19, 'LANGUAGES', 'LANGUAGES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1067, 19, 'LEISURE', 'LEISURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1068, 19, 'MASS COMMUNICATIONS AND DOCUMENTATION', 'MASS COMMUNICATIONS AND DOCUMENTATION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1069, 19, 'MATHEMATICAL SCIENCES AND INFORMATICS', 'MATHEMATICAL SCIENCES AND INFORMATICS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1070, 19, 'MEDICINE', 'MEDICINE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1071, 19, 'PHYSICAL SCIENCES', 'PHYSICAL SCIENCES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1072, 19, 'SOCIAL STUDIES', 'SOCIAL STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1073, 19, 'OTHER', 'OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1074, 20, 'P', 'Home');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1075, 20, 'H', 'Elsewhere');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1076, 20, 'O', 'London');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1077, 20, 'R', 'Restricted Home');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1078, 20, 'X', 'Restricted Elsewhere');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1079, 21, 'A', 'Non Fee Loan Bearing');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1080, 21, 'B', 'Loan Restricted ¿ Eligibility');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1081, 21, 'C', 'Fee Loan Restricted ¿ Entitlement');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1082, 21, 'D', 'No Fee Loan Claimed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1083, 21, 'E', 'Fee Loan Amount Claimed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1084, 21, 'F', 'Maximum Fee Loan Claimed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1085, 22, 'A', 'Non Loan Bearing');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1086, 22, 'B', 'Loan Restricted ¿ Eligibility');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1087, 22, 'C', 'Loan Restricted ¿ Application');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1088, 22, 'D', 'No loan Claimed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1089, 22, 'E', 'Loan Amount Claimed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1090, 22, 'F', 'Maximum Loan Claimed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1091, 23, 'JA', 'Joint Account');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1092, 23, 'RU', 'Account Number Reused After 5 yrs');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1093, 24, 'No Child Benefit', 'No Child Benefit');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1094, 24, 'Non UK', 'Non UK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1095, 24, 'Other', 'Other');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1096, 24, 'Refugee', 'Refugee');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1097, 25, 'A', 'Payments in order');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1098, 25, 'B', 'Student in overpayment');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1099, 25, 'C', 'Student in debtor category');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1100, 25, 'D', 'Debt written-off');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1101, 25, 'E', 'Debt waived');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1102, 26, 'N', 'New Application');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1103, 26, 'R', 'Returned Application');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1104, 26, 'C', 'Rejected Application');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1105, 26, 'W', 'Calculated');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1106, 26, 'T', 'Withdrawn');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1107, 26, 'A', 'Non-Attendance');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1108, 27, 'R', 'REFUSED');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1109, 27, 'I', 'REINSTATED');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1110, 28, 'P', 'Previous');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1111, 28, 'C', 'Current');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1112, 29, 'P', 'Provisional');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1113, 29, 'F', 'Final');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1114, 30, 'R', 'Rejected');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1115, 30, 'E', 'Data error');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1116, 30, 'S', 'Sent');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1117, 30, 'C', 'Corrected');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1118, 31, 'Y', 'YES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1119, 31, 'N', 'NO');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1120, 32, 'T', 'TRUE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1121, 32, 'F', 'FALSE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1122, 33, 'S', 'Single');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1123, 33, 'M', 'Married');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1124, 33, 'D', 'Divorced');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1125, 33, 'A', 'Separated (new)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1126, 33, 'W', 'Widowed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1127, 33, 'P', 'Living with partner');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1128, 34, 'U', 'Unemployed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1129, 34, 'S', 'Self-employed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1130, 34, 'E', 'Employed');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1131, 34, 'H', 'House person');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1132, 34, 'D', 'Disabled');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1133, 35, 'H', 'Husband');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1134, 35, 'W', 'Wife');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1135, 35, 'P', 'Partner');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1136, 35, 'S', 'Spouse');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1137, 36, 'NO DISABILITY', 'NO DISABILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1138, 36, 'DYSLEXIA', 'DYSLEXIA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1139, 36, 'BLIND/PARTIAL SIGHT', 'BLIND/PARTIAL SIGHT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1140, 36, 'DEAF/PARTIAL HEARING', 'DEAF/PARTIAL HEARING');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1141, 36, 'WHEELCHAIR/MOBILITY', 'WHEELCHAIR/MOBILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1142, 36, 'PERSONAL CARE', 'PERSONAL CARE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1143, 36, 'MENTAL HEALTH', 'MENTAL HEALTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1144, 36, 'UNSEEN DISABILITY', 'UNSEEN DISABILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1145, 36, 'MULTIPLE DISABILITIES', 'MULTIPLE DISABILITIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1146, 36, 'OTHER DISABILITY', 'OTHER DISABILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1147, 36, 'UNCONDITIONAL OFFER', 'UNCONDITIONAL OFFER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1148, 36, 'CERTIFICATE OF TRANSFER', 'CERTIFICATE OF TRANSFER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1149, 37, 'S', 'Sibling');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1150, 37, 'P', 'Parent/Child');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1151, 38, 'Daughter', 'Daughter');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1152, 38, 'Niece', 'Niece (Child)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1153, 38, 'Nephew', 'Nephew (Child)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1154, 38, 'Sister', 'Sister (Child)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1155, 38, 'Brother', 'Brother (Child)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1156, 38, 'Stepdaughter', 'Stepdaughter');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1157, 38, 'Stepson', 'Stepson');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1158, 38, 'Other', 'Other');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1159, 38, 'Son', 'Son');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1160, 39, 'Stepmother', 'Stepmother');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1161, 39, 'Niece', 'Niece');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1162, 39, 'Nephew', 'Nephew');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1163, 39, 'Spouse', 'Spouse');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1164, 39, 'Other', 'Other');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1165, 39, 'Stepfather', 'Stepfather');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1166, 39, 'Brother', 'Brother');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1167, 39, 'Grandfather', 'Grandfather');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1168, 39, 'Uncle', 'Uncle');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1169, 39, 'Aunt', 'Aunt');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1170, 39, 'Mother', 'Mother ');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1171, 39, 'Father', 'Father');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1172, 39, 'Sister', 'Sister');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1173, 39, 'Grandmother', 'Grandmother');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (1, 6, 'grass category', 'HIGHER EDUCATION INSTITUTION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (2, 6, 'grass category', 'COLLEGE OF FURTHER EDUCATION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (3, 6, 'grass category', 'COLLEGE OF NURSE AND MIDWIFERY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (4, 6, 'grass category', 'THEOLOGICAL COLLEGE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (5, 6, 'grass category', 'NHS COLLEGE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (6, 6, 'grass category', 'ADULT EDUCATION COLLEGE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (7, 6, 'grass category', 'OTHER INSTITUTION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (21, 2, 'grass category', 'FATHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (22, 2, 'grass category', 'MOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (23, 2, 'grass category', 'STEPFATHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (24, 2, 'grass category', 'STEPMOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (34, 4, 'grass category', 'BROTHER (ADULT)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (35, 4, 'grass category', 'SISTER (ADULT)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (36, 4, 'grass category', 'FATHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (37, 4, 'grass category', 'MOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (38, 4, 'grass category', 'AUNT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (39, 4, 'grass category', 'UNCLE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (40, 4, 'grass category', 'GRANDFATHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (41, 4, 'grass category', 'GRANDMOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (42, 4, 'grass category', 'STEPFATHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (43, 4, 'grass category', 'STEPMOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (50, 9, 'grass category', 'NO DISABILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (51, 9, 'grass category', 'DYSLEXIA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (52, 9, 'grass category', 'BLIND/PARTIAL SIGHT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (53, 9, 'grass category', 'DEAF/PARTIAL HEARING');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (54, 9, 'grass category', 'WHEELCHAIR/MOBILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (55, 9, 'grass category', 'PERSONAL CARE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (56, 9, 'grass category', 'MENTAL HEALTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (57, 9, 'grass category', 'UNSEEN DISABILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (58, 9, 'grass category', 'MULTIPLE DISABILITIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (59, 9, 'grass category', 'OTHER DISABILITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (71, 1, 'grass category', 'UNCONDITIONAL OFFER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (72, 1, 'grass category', 'CERTIFICATE OF TRANSFER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (73, 1, 'grass category', 'PROOF OF EXEMPTION FROM PARCON');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (74, 1, 'grass category', 'EVIDENCE OF ELIGIBILITY FROM MSA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (75, 1, 'grass category', 'EVIDENCE IN SUPPORT OF OPTIONAL ALLOWANCE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (76, 1, 'grass category', 'MARRIAGE CERTIFICATE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (77, 1, 'grass category', 'EVIDENCE OF TENANCY/HOME OWNERSHIP');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (78, 1, 'grass category', 'DIVORCE DECREE OR SOLICITOR`S LETTER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (79, 1, 'grass category', 'EVIDENCE OF PARENTAL OF SPOUSE INCOME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (80, 1, 'grass category', 'EVIDENCE OF ALLOWABLE DEDUCTIONS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (81, 1, 'grass category', 'BIRTH CERTIFICATE OF DEPENDANT CHILDREN (BENEFACTOR`S OR STUDENT`S)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (82, 1, 'grass category', 'EVIDENCE OF STUDENT INCOME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (83, 1, 'grass category', 'EVIDENCE OF DEPENDANT`S INCOME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (84, 1, 'grass category', 'EVIDENCE OF SPONSORSHIP');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (85, 1, 'grass category', 'EVIDENCE JUSTIFYING DSA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (101, 8, 'grass category', 'ENGLISH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (102, 8, 'grass category', 'HISTORY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (103, 8, 'grass category', 'LAW');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (104, 8, 'grass category', 'PHILOSOPHY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (105, 8, 'grass category', 'LITERATURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (106, 8, 'grass category', 'LINGUISTICS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (107, 8, 'grass category', 'FILM AND THEATRE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (108, 8, 'grass category', 'ART HISTORY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (109, 8, 'grass category', 'ARCHAEOLOGY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (110, 8, 'grass category', 'CLASSICS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (111, 8, 'grass category', 'THEOLOGY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (112, 8, 'grass category', 'MUSIC');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (113, 8, 'grass category', 'PUBLISHING STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (114, 8, 'grass category', 'FRENCH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (115, 8, 'grass category', 'GERMAN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (116, 8, 'grass category', 'ITALIAN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (117, 8, 'grass category', 'HISPANIC STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (118, 8, 'grass category', 'JAPANESE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (119, 8, 'grass category', 'EUROPEAN STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (120, 8, 'grass category', 'ART AND DESIGN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (121, 8, 'grass category', 'CELTIC/IRISH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (122, 8, 'grass category', 'RUSSIAN');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (123, 8, 'grass category', 'SCOTTISH STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (124, 8, 'grass category', 'HUMAN RIGHTS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (125, 8, 'grass category', 'ORIENTAL STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (126, 8, 'grass category', 'ARCHITECTURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (127, 8, 'grass category', 'SLAVONIC');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (128, 8, 'grass category', 'SPANISH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (129, 8, 'grass category', 'AGRICULTURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (130, 8, 'grass category', 'ALLIED TO MEDICINE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (131, 8, 'grass category', 'ARCHITECTURE,BUILDING AND PLANNING');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (132, 8, 'grass category', 'BIOLOGICAL SCIENCES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (133, 8, 'grass category', 'BUSINESS AND ADMINISTRATIVE STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (134, 8, 'grass category', 'CATERING');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (135, 8, 'grass category', 'COMBINED OR GENERAL');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (136, 8, 'grass category', 'CREATIVE ARTS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (137, 8, 'grass category', 'DENTISTRY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (138, 8, 'grass category', 'EDUCATION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (139, 8, 'grass category', 'ENGINEERING AND TECHNOLOGY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (140, 8, 'grass category', 'HUMANITIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (141, 8, 'grass category', 'LANGUAGES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (142, 8, 'grass category', 'LEISURE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (143, 8, 'grass category', 'MASS COMMUNICATIONS AND DOCUMENTATION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (144, 8, 'grass category', 'MATHEMATICAL SCIENCES AND INFORMATICS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (145, 8, 'grass category', 'MEDICINE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (146, 8, 'grass category', 'PHYSICAL SCIENCES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (147, 8, 'grass category', 'SOCIAL STUDIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (148, 8, 'grass category', 'OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (201, 10, 'grass category', 'EDUCATION AUTHORITIES BURSARIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (202, 10, 'grass category', 'ELIGIBILITY:RESIDENCE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (301, 11, 'grass category', 'SCOTLAND');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (302, 11, 'grass category', 'ENGLAND NON-LONDON');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (303, 11, 'grass category', 'ENGLAND LONDON');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (304, 11, 'grass category', 'REPUBLIC OF IRELAND');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (305, 11, 'grass category', 'NORTHERN IRELAND');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (306, 11, 'grass category', 'WALES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (307, 11, 'grass category', 'EUROPEAN UNION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (308, 11, 'grass category', 'OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (401, 12, 'grass category', 'C DUMMY 1');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (402, 12, 'grass category', 'C DUMMY 2');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (501, 7, 'grass category', 'SCOTLAND');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (502, 7, 'grass category', 'REST OF BRITISH ISLES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (503, 7, 'grass category', 'EUROPEAN COMMUNITY');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (504, 7, 'grass category', 'ELSEWHERE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (49, 4, 'grass category', 'WIFE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (510, 5, 'grass category', 'STEPSON');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (203, 10, 'grass category', 'ELIGIBILITY:COURSE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (204, 10, 'grass category', 'EXTENSION OF GRANT:SECOND/POST GRADUATE COURSE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (205, 10, 'grass category', 'EXTENSION OF GRANT:CHANGE OF COURSE/REPEAT YEAR/HONOURS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (206, 10, 'grass category', 'APPLICATION OF PARENTAL CONTRIBUTION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (207, 10, 'grass category', 'DEPENDANTS'' ALLOWANCE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (208, 10, 'grass category', 'TRAVEL EXPENSES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (209, 10, 'grass category', 'ASSESSMENT(INCLUDING OVERPAYMENTS)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (210, 10, 'grass category', 'DELAY IN RESPONDING TO ENQUIRIES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (508, 4, 'grass category', 'NIECE (ADULT)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (509, 4, 'grass category', 'NEPHEW (ADULT)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (511, 5, 'grass category', 'STEPDAUGHTER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (403, 12, 'grass category', '1ST MONDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (404, 12, 'grass category', '1ST TUESDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (405, 12, 'grass category', '1ST MONDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (406, 12, 'grass category', '1ST TUESDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (407, 12, 'grass category', '1ST WEDNESDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (408, 12, 'grass category', '1ST WEDNESDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (211, 10, 'grass category', 'LATE PAYMENT OF GRANT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (212, 10, 'grass category', 'SCOTTISH STUDENTSHIP SCHEME');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (600, 5, 'grass category', 'BROTHER (CHILD)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (601, 5, 'grass category', 'SISTER (CHILD)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (602, 5, 'grass category', 'NEPHEW (CHILD)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (603, 5, 'grass category', 'NIECE (CHILD)');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (213, 10, 'grass category', 'LATE APPLICATION REFUSALS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (214, 10, 'grass category', 'RATE OF UK AWARDS AND LOANS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (215, 10, 'grass category', 'WITHDRAWAL OF BENEFITS');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (216, 10, 'grass category', 'GRANT/LOAN SHIFT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (217, 10, 'grass category', 'STUDENT LOAN CO.(ENQUIRY INTO OPERATING PROCEDURES & GENERAL');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (218, 10, 'grass category', 'WITHDRAWAL OF MSA');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (219, 10, 'grass category', 'OTHER SUBJECTS INCLUDING COMPOSITE OF ABOVE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (220, 10, 'grass category', 'FUTURE STUDENT SUPPORT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (221, 10, 'grass category', 'INDIVIDUAL ELIGIBILITY:FUTURE STUDENT SUPPORT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (25, 2, 'grass category', 'GRANDFATHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (26, 2, 'grass category', 'GRANDMOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (27, 2, 'grass category', 'UNCLE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (29, 2, 'grass category', 'AUNT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (409, 12, 'grass category', '1ST THURSDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (410, 12, 'grass category', '1ST THURSDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (411, 12, 'grass category', '1ST FRIDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (412, 12, 'grass category', '2ND MONDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (413, 12, 'grass category', '2ND TUESDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (414, 12, 'grass category', '2ND WEDNESDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (415, 12, 'grass category', '2ND THURSDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (416, 12, 'grass category', '2ND FRIDAY WEEK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (417, 12, 'grass category', '1ST FRIDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (418, 12, 'grass category', '2ND MONDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (419, 12, 'grass category', '2ND TUESDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (420, 12, 'grass category', '2ND WEDNESDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (421, 12, 'grass category', '2ND THURSDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (422, 12, 'grass category', '2ND FRIDAY MONTH');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (423, 12, 'grass category', 'ENGLAND AND WALES');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (801, 13, 'grass category', 'CONTINUING STUDENT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (802, 13, 'grass category', 'REPEAT YEAR');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (803, 13, 'grass category', 'POST GRAD THIS SESSION');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (804, 13, 'grass category', 'GAP YEAR');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (805, 13, 'grass category', 'OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (901, 14, 'grass category', 'MISSING - VALID REASON - NO CHILD BENEFIT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (902, 14, 'grass category', 'MISSING - VALID REASON - NON UK');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (903, 14, 'grass category', 'MISSING - VALID REASON - OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (904, 14, 'grass category', 'MISSING - VALID REASON - REFUGEE');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (30, 2, 'grass category', 'FATHER or MOTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (31, 2, 'grass category', 'PARENTS PARTNER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (32, 2, 'grass category', 'STEP PARENT');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (28, 3, 'grass category', 'HUSBAND, WIFE OR PARTNER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (99, 2, 'grass category', 'OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (46, 5, 'grass category', 'SON');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (47, 5, 'grass category', 'DAUGHTER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (705, 5, 'grass category', 'OTHER');
Insert into REFERENCE_DATA
   (ID, REF_TYPE_ID, SHORT_NAME, DESCRIPTION)
 Values
   (48, 4, 'grass category', 'SPOUSE');
COMMIT;
