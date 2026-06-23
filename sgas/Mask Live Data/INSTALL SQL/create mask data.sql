set timing on;
WHENEVER SQLERROR CONTINUE;


DROP SEQUENCE SGAS.ST_STUD_REF_NO_SEQ;

CREATE SEQUENCE SGAS.ST_STUD_REF_NO_SEQ
 INCREMENT BY 1
 MINVALUE 90000001
 MAXVALUE 999999999999
 NOCACHE
 NOCYCLE
 NOORDER;

DELETE FROM zz_mask_column;--  where order_number > 77;

SET DEFINE OFF;
--SQL Statement which produced this data:
--
--  SELECT *
--  FROM ZZ_MASK_COLUMN
--  ORDER BY ORDER_NUMBER;
--
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'DOB', 'DOB', 1);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'TITLE', 'STUD_NAME', 2);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'INITIALS', 'STUD_NAME', 3);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'FORENAMES', 'STUD_NAME', 4);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'SURNAME', 'STUD_NAME', 5);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'SCOTTISH_CAND', 'SLC', 6);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NI_NO', 'NINO', 7);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'ACCOUNT_NO', 'ACCOUNT_NO', 8);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'SORT_CODE', 'SORT_CODE', 9);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'MOBILE_TEL_NO', 'TEL_NO', 10);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_NAME', 'NULL', 11);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS_', 'STUD', 'BANK_HOUSE_NO_NAME', 'NULL', 12);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_ADDR_L1', 'NULL', 13);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_ADDR_L2', 'NULL', 14);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_ADDR_L3', 'NULL', 15);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_ADDR_L4', 'NULL', 16);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_POST_CODE', 'NULL', 17);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_ACCOUNT', 'NULL', 18);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_SORT_CODE', 'NULL', 19);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_NAME', 'NULL', 20);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_NAME', 'NULL', 21);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_HOUSE', 'NULL', 22);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_ADDR_L1', 'NULL', 23);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_ADDR_L2', 'NULL', 24);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_ADDR_L3', 'NULL', 25);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_ADDR_L4', 'NULL', 26);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NOM_BANK_POST_CODE', 'NULL', 27);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BUILD_SOC_NO', 'NULL', 28);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'EMAIL_ADDR', 'STUD_EMAIL', 29);   
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'HOUSE_NO_NAME', 'STUD_ADDRESS', 30);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'ADDR_L1', 'STUD_ADDRESS', 31);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'ADDR_L2', 'STUD_ADDRESS', 32);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'ADDR_L3', 'STUD_ADDRESS', 33);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'ADDR_L4', 'STUD_ADDRESS', 34);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'POST_CODE', 'STUD_ADDRESS', 35);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR', 'TELE_NO', 'TEL_NO', 36);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'HOUSE_NO_NAME', 'STUD_ADDRESS', 37);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'ADDR_L1', 'STUD_ADDRESS', 38);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'ADDR_L2', 'STUD_ADDRESS', 39);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'ADDR_L3', 'STUD_ADDRESS', 40);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'ADDR_L4', 'STUD_ADDRESS', 41);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'POST_CODE', 'STUD_ADDRESS', 42);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_HOME_ADDR_WEB', 'TELE_NO', 'TEL_NO', 43);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'HOUSE_NO_NAME', 'STUD_ADDRESS', 44);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'ADDR_L1', 'STUD_ADDRESS', 45);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'ADDR_L2', 'STUD_ADDRESS', 46);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'ADDR_L3', 'STUD_ADDRESS', 47);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'ADDR_L4', 'STUD_ADDRESS', 48);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'POST_CODE', 'STUD_ADDRESS', 49);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR', 'TELE_NO', 'TEL_NO', 50);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'HOUSE_NO_NAME', 'STUD_ADDRESS', 51);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'ADDR_L1', 'STUD_ADDRESS', 52);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'ADDR_L2', 'STUD_ADDRESS', 53);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'ADDR_L3', 'STUD_ADDRESS', 54);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'ADDR_L4', 'STUD_ADDRESS', 55);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'POST_CODE', 'STUD_ADDRESS', 56);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_TERM_ADDR_WEB', 'TELE_NO', 'TEL_NO', 57);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS', 'CONT_ADDR1', 'STUD_ADDRESS', 58);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS', 'CONT_ADDR2', 'STUD_ADDRESS', 59);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS', 'CONT_ADDR3', 'STUD_ADDRESS', 60);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS', 'CONT_POSTCODE', 'STUD_ADDRESS', 61);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS', 'CONT_TEL_NO', 'TEL_NO', 62);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS_WEB', 'CONT_ADDR1', 'STUD_ADDRESS', 63);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS_WEB', 'CONT_ADDR2', 'STUD_ADDRESS', 64);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS_WEB', 'CONT_ADDR3', 'STUD_ADDRESS', 65);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS_WEB', 'CONT_POSTCODE', 'STUD_ADDRESS', 66);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_CONT_DETAILS_WEB', 'CONT_TEL_NO', 'TEL_NO', 67);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'ACCOUNT_NAME', 'ACCOUNT_NAME', 68);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'SORT_CODE', 'SORT_CODE', 69);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'ACCOUNT_NO', 'ACCOUNT_NO', 70);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'PAYEE_ADDRL1', 'STUD_ADDRESS', 71);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'PAYEE_ADDRL2', 'STUD_ADDRESS', 72);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'PAYEE_ADDRL3', 'STUD_ADDRESS', 73);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'PAYMENT_INSTALMENT', 'PAYEE_POSTCODE', 'STUD_ADDRESS', 74);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_DEPENDANT', 'FIRST_NAME', 'STUD_DEPENDANT_NAME', 75);

Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_DEPENDANT', 'SURNAME', 'STUD_DEPENDANT_NAME', 76);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD_DEPENDANT', 'DOB', 'DOB', 77);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'FORENAME', 'NOMINEE', 78);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'SURNAME', 'NOMINEE', 79);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'COMPANY_NAME', 'NOMINEE', 80);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'PAYEE_NAME', 'NOMINEE', 81);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'HOUSE_NO_NAME', 'NOMINEE', 82);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'ADDR_L1', 'NOMINEE', 83);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'ADDR_L2', 'NOMINEE', 84);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'ADDR_L3', 'NOMINEE', 85);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'ADDR_L4', 'NOMINEE', 86);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'POST_CODE', 'NOMINEE', 87);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'TELEPHONE_NO', 'TEL_NO', 88);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'ACCOUNT_NO', 'NOMINEE', 89);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'NOMINEE', 'SORT_CODE', 'SORT_CODE', 90);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'TITLE', 'BENEFACTOR', 91);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'INITIALS', 'BENEFACTOR', 92);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'FORENAMES', 'BENEFACTOR', 93);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'SURNAME', 'BENEFACTOR', 94);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'HOUSE_NO_NAME', 'BENEFACTOR', 95);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'ADDR_L1', 'BENEFACTOR', 96);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'ADDR_L2', 'BENEFACTOR', 97);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'ADDR_L3', 'BENEFACTOR', 98);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'ADDR_L4', 'BENEFACTOR', 99);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'POST_CODE', 'BENEFACTOR', 100);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'BEN_NI_NO', 'NINO', 101);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'TELE_NO', 'TEL_NO', 102);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'TITLE', 'BENEFACTOR', 103);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR', 'INITIALS', 'BENEFACTOR', 104);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'FORENAMES', 'BENEFACTOR', 105);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'SURNAME', 'BENEFACTOR', 106);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'HOUSE_NO_NAME', 'BENEFACTOR', 107);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'ADDR_L1', 'BENEFACTOR', 108);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'ADDR_L2', 'BENEFACTOR', 109);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'ADDR_L3', 'BENEFACTOR', 110);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'ADDR_L4', 'BENEFACTOR', 111);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'POST_CODE', 'BENEFACTOR', 112);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'BEN_NI_NO', 'NINO', 113);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'BENEFACTOR_WEB', 'TELE_NO', 'TEL_NO', 114);
COMMIT;

INSERT INTO zz_mask_column (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER, NEW_KEY_TABLE_NAME, NEW_KEY_COLUMN_NAME)
SELECT 'SGAS' SCHEMA_NAME, C.TABLE_NAME, 'STUD_REF_NO' COLUMN_NAME, 'NEW_KEY' MASK_NAME, 
         (select max(order_number) from zz_mask_column) + ROWNUM ORDER_NUMBER,
        'STUD' NEW_KEY_TABLE_NAME,
        'STUD_REF_NO' NEW_KEY_COLUMN_NAME 
  FROM all_tab_cols c
 WHERE     C.OWNER = 'SGAS'
       AND C.COLUMN_NAME = 'STUD_REF_NO'
       AND C.TABLE_NAME NOT like 'ZZ%'
       AND C.TABLE_NAME NOT like 'TEMP%'
       AND C.TABLE_NAME NOT like 'MASK_%'
       AND C.TABLE_NAME NOT IN ('STUD',
                                'ZZ_MASK_STUD_NAME',
                                'UAT_TEST_CASE_TEMP',
                                'WMBBFBVLBA',
                                'WMBBHB4BFZ',
                                'VU_HISTORY',
                                'VU_AWARD_NOTIFICATION_STUD');
                                

DELETE FROM zz_mask_table;

INSERT INTO zz_mask_table 
SELECT ROWNUM ORDER_NUMBER, 'SGAS' SCHEMA_NAME, X.TABLE_NAME
FROM (SELECT C.TABLE_NAME
  FROM all_tab_cols c
 WHERE     C.OWNER = 'SGAS'
       AND C.COLUMN_NAME = 'STUD_REF_NO'
       AND C.TABLE_NAME NOT like 'ZZ%'
       AND C.TABLE_NAME NOT like 'TEMP%'
       AND C.TABLE_NAME NOT like 'MASK_%'
       AND C.TABLE_NAME NOT IN ('STUD',
                                'ZZ_MASK_STUD_NAME',
                                'UAT_TEST_CASE_TEMP',
                                'WMBBFBVLBA',
                                'WMBBHB4BFZ',
                                'VU_HISTORY',
                                'VU_AWARD_NOTIFICATION_STUD')
UNION ALL                                
SELECT 'STUD' TABLE_NAME FROM DUAL) X;


DELETE FROM zz_mask_INDEX;

INSERT INTO zz_mask_INDEX (SCHEMA_NAME, TABLE_NAME, INDEX_NAME)
  SELECT 'SGAS' SCHEMA_NAME, X.TABLE_NAME, X.INDEX_NAME
    FROM (  SELECT a.index_name,
                   B.INDEX_TYPE,
                   B.UNIQUENESS,
                   B.OWNER,
                   B.TABLE_NAME,
                   LISTAGG (A.column_name, ',')
                      WITHIN GROUP (ORDER BY A.column_position)
                      index_columns
              FROM all_ind_columns a, all_indexes b
             WHERE     b.owner = 'SGAS'
                  AND B.TABLE_NAME NOT like 'ZZ%'
                  AND B.TABLE_NAME NOT like 'TEMP%'
                  AND B.TABLE_NAME NOT like 'MASK_%'
                  AND B.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
                                            'WMBBFBVLBA',
                                            'WMBBHB4BFZ',
                                            'VU_HISTORY',
                                            'VU_AWARD_NOTIFICATION_STUD')
                   AND b.index_name = a.index_name
                   AND b.owner = a.index_owner
          GROUP BY a.index_name,
                   B.INDEX_TYPE,
                   B.UNIQUENESS,
                   B.OWNER,
                   B.TABLE_NAME) X
   WHERE X.INDEX_COLUMNS LIKE '%STUD_REF_NO%'
ORDER BY 1, 2, 3;


DELETE FROM ZZ_MASK_CONSTRAINT;


INSERT INTO ZZ_MASK_CONSTRAINT (SCHEMA_NAME, TABLE_NAME, CONSTRAINT_NAME, ORDER_NUMBER)
  SELECT 'SGAS' SCHEMA_NAME, X.TABLE_NAME, X.CONSTRAINT_NAME, ROWNUM ORDER_NUMBER
    FROM (  SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM all_cons_columns a, all_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND a.owner = 'SGAS'
                   AND B.CONSTRAINT_TYPE != 'P'
                   AND A.TABLE_NAME NOT like 'ZZ%'
                   AND A.TABLE_NAME NOT like 'TEMP%'
                   AND A.TABLE_NAME NOT like 'MASK_%'
                   AND A.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
                                            'WMBBFBVLBA',
                                            'WMBBHB4BFZ',
                                            'VU_HISTORY',
                                            'VU_AWARD_NOTIFICATION_STUD')
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name    
          UNION ALL
          SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM all_cons_columns a, all_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND a.owner = 'SGAS'
                   AND B.CONSTRAINT_TYPE = 'P'
                  AND A.TABLE_NAME NOT like 'ZZ%'
                   AND A.TABLE_NAME NOT like 'TEMP%'
                   AND A.TABLE_NAME NOT like 'MASK_%'
                   AND A.TABLE_NAME != 'STUD'
                   AND A.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
                                            'WMBBFBVLBA',
                                            'WMBBHB4BFZ',
                                            'VU_HISTORY',
                                            'VU_AWARD_NOTIFICATION_STUD')
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name    
          UNION ALL
          SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM all_cons_columns a, all_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND a.owner = 'SGAS'
                   AND B.CONSTRAINT_TYPE = 'P'
                   AND A.TABLE_NAME NOT like 'ZZ%'
                   AND A.TABLE_NAME NOT like 'TEMP%'
                   AND A.TABLE_NAME NOT like 'MASK_%'
                  AND A.TABLE_NAME = 'STUD'
                   AND A.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
                                            'WMBBFBVLBA',
                                            'WMBBHB4BFZ',
                                            'VU_HISTORY',
                                            'VU_AWARD_NOTIFICATION_STUD')
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name) X
   WHERE X.fk_columns LIKE '%STUD_REF_NO%';

DROP table zz_mask_stud_name;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_stud_name
AS
WITH c_stud
AS
(SELECT /*+ parallel(b,10) */ ROWNUM num_row, b.stud_ref_no, b.title, b.initials, b.forenames,b.surname
FROM stud b)
SELECT ROWNUM record_no, x.*,
       99999999 stud_ref_no
FROM (SELECT DISTINCT na.*
FROM (SELECT DISTINCT n.title,
       LAG(n.initials,1,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,2,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT n.title,
       LAG(n.initials,2,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,6,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,4,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT n.title,
       LAG(n.initials,3,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,8,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,1,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT n.title,
       LAG(n.initials,4,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,2,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n) na
WHERE NOT EXISTS (SELECT 1
                  FROM c_stud b
                  WHERE b.forenames = na.forenames
                  AND b.surname = na.surname) ) x;


CREATE INDEX SGAS.MSN_ST2 ON SGAS.ZZ_MASK_STUD_NAME
(RECORD_NO)
COMPUTE STATISTICS;


DECLARE
        
   TYPE t_record_no_tab IS TABLE OF number;
   l_tab_record_no t_record_no_tab := t_record_no_tab();
   TYPE T_STUD_TAB IS TABLE OF STUD.STUD_REF_NO%TYPE;
   l_tab_stud_ref_no T_STUD_TAB := T_STUD_TAB();
   CURSOR C_STUD
   IS
        SELECT rownum record_no, S.STUD_REF_NO
          FROM STUD S
      ORDER BY S.STUD_REF_NO;
BEGIN
   UPDATE ZZ_MASK_STUD_NAME
      SET STUD_REF_NO = NULL;

    OPEN C_STUD;
    LOOP
    FETCH C_STUD BULK COLLECT INTO l_tab_record_no, l_tab_stud_ref_no LIMIT 1000;

    FORALL i IN l_tab_record_no.first .. l_tab_record_no.last

      UPDATE ZZ_MASK_STUD_NAME S
         SET S.STUD_REF_NO = l_tab_stud_ref_no(i)
       WHERE S.RECORD_NO = l_tab_record_no(i);
                             
    EXIT WHEN C_STUD%NOTFOUND;
    END LOOP;
    CLOSE C_STUD;
      
   COMMIT;
END;

CREATE INDEX SGAS.MSN_ST1 ON SGAS.zz_mask_stud_name
(STUD_REF_NO)
COMPUTE STATISTICS;

DROP table zz_mask_stud_address;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_stud_address
AS
WITH c_stud
AS
(SELECT /*+ parallel(b,10) */ 
        ROWNUM num_row, 
        b.stud_ref_no, 
        B.HOUSE_NO_NAME,
        b.ADDR_L1,
        b.ADDR_L2,
        b.ADDR_L3,
        b.ADDR_L4,
        b.POST_CODE,
        TELE_NO        
FROM stud_home_addr b  )
SELECT ROWNUM record_no, x.*,
       99999999 stud_ref_no
FROM (SELECT DISTINCT na.*
FROM (SELECT DISTINCT 
       LAG(n.HOUSE_NO_NAME,1,'') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,2,'Dummy Line 1') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,3,'Dummy Line 2') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L2,4,'Dummy Line 3') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L2,3,'Dummy Line 4') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,5,'EH87KK') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_stud n
UNION
SELECT DISTINCT 
       LAG(n.HOUSE_NO_NAME,2,'') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,36,'Dummy Line 1') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,4,'Dummy Line 2') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L2,5,'Dummy Line 3') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L2,6,'Dummy Line 4') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,3,'EH87KK') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_stud n
UNION
SELECT DISTINCT 
       LAG(n.HOUSE_NO_NAME,3,'') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,8,'Dummy Line 1') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,6,'Dummy Line 2') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L2,5,'Dummy Line 3') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L2,5,'Dummy Line 4') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,2,'EH87KK') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_stud n
UNION
SELECT DISTINCT 
       LAG(n.HOUSE_NO_NAME,4,'') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,7,'Dummy Line 1') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,5,'Dummy Line 2') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L2,6,'Dummy Line 3') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L2,7,'Dummy Line 1') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,6,'EH87KK') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_stud n) na
WHERE NOT EXISTS (SELECT 1
                  FROM c_stud b
                  WHERE b.ADDR_L1 = na.ADDR_L1
                  and b.post_code = na.post_code) ) x;


CREATE INDEX SGAS.MSA_ST2 ON SGAS.zz_mask_stud_address
(RECORD_NO)
COMPUTE STATISTICS;


DECLARE
        
   TYPE t_record_no_tab IS TABLE OF number;
   l_tab_record_no t_record_no_tab := t_record_no_tab();
   TYPE T_STUD_TAB IS TABLE OF STUD.STUD_REF_NO%TYPE;
   l_tab_stud_ref_no T_STUD_TAB := T_STUD_TAB();
   CURSOR C_STUD
   IS
        SELECT rownum record_no, S.STUD_REF_NO
          FROM STUD S
      ORDER BY S.STUD_REF_NO;
BEGIN
   UPDATE zz_mask_stud_address
      SET STUD_REF_NO = NULL;

    OPEN C_STUD;
    LOOP
    FETCH C_STUD BULK COLLECT INTO l_tab_record_no, l_tab_stud_ref_no LIMIT 1000;

    FORALL i IN l_tab_record_no.first .. l_tab_record_no.last

      UPDATE zz_mask_stud_address S
         SET S.STUD_REF_NO = l_tab_stud_ref_no(i)
       WHERE S.RECORD_NO = l_tab_record_no(i);
                             
    EXIT WHEN C_STUD%NOTFOUND;
    END LOOP;
    CLOSE C_STUD;
      
   COMMIT;
END;

CREATE INDEX SGAS.MSA_ST1 ON SGAS.zz_mask_stud_address
(STUD_REF_NO)
COMPUTE STATISTICS;

DROP table zz_mask_nominee;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_nominee
AS
WITH c_nominee
AS
(SELECT /*+ parallel(b,10) */ ROWNUM num_row, b.NOMINEE_ID, b.forename,b.surname,
         B.PAYEE_NAME, B.HOUSE_NO_NAME, B.ADDR_L1, B.ADDR_L2, B.ADDR_L3, B.ADDR_L4,
         B.POST_CODE
FROM nominee b)
SELECT ROWNUM record_no, x.forename,x.surname,
         x.PAYEE_NAME, x.HOUSE_NO_NAME, x.ADDR_L1, x.ADDR_L2, x.ADDR_L3, x.ADDR_L4,
         x.POST_CODE,
       99999999 NOMINEE_ID
FROM (SELECT DISTINCT na.*
FROM /* Formatted on 23/11/2016 13:59:20 (QP5 v5.256.13226.35538) */
(SELECT DISTINCT
       LAG(n.forename,1,'Scott') OVER(ORDER BY n.num_row) AS forename,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.forename,1,'Scott') OVER(ORDER BY n.num_row) || ' '||LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS company_name,
       LAG(n.payee_name,5,'Dummy') OVER(ORDER BY n.num_row) AS payee_name,
       LAG(n.HOUSE_NO_NAME,6,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,1,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,2,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,6,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_nominee n
UNION
SELECT DISTINCT 
       LAG(n.forename,2,'Scott') OVER(ORDER BY n.num_row) AS forename,
       LAG(n.SURNAME,5,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.forename,2,'Scott') OVER(ORDER BY n.num_row) || ' '||LAG(n.SURNAME,5,'Dummy') OVER(ORDER BY n.num_row) AS company_name,
       LAG(n.payee_name,3,'Dummy') OVER(ORDER BY n.num_row) AS payee_name,
       LAG(n.HOUSE_NO_NAME,6,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,5,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,2,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,1,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_nominee n
UNION
SELECT DISTINCT 
       LAG(n.forename,3,'Scott') OVER(ORDER BY n.num_row) AS forename,
       LAG(n.SURNAME,8,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.forename,3,'Scott') OVER(ORDER BY n.num_row) || ' '||LAG(n.SURNAME,8,'Dummy') OVER(ORDER BY n.num_row) AS company_name,
       LAG(n.payee_name,5,'Dummy') OVER(ORDER BY n.num_row) AS payee_name,
       LAG(n.HOUSE_NO_NAME,2,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,1,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,5,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,7,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_nominee n
UNION
SELECT DISTINCT 
       LAG(n.forename,1,'Scott') OVER(ORDER BY n.num_row) AS forename,
       LAG(n.SURNAME,9,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.forename,1,'Scott') OVER(ORDER BY n.num_row) || ' '||LAG(n.SURNAME,9,'Dummy') OVER(ORDER BY n.num_row) AS company_name,
       LAG(n.payee_name,7,'Dummy') OVER(ORDER BY n.num_row) AS payee_name,
       LAG(n.HOUSE_NO_NAME,6,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,5,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,7,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,4,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_nominee n) na
WHERE NOT EXISTS (SELECT 1
                  FROM c_nominee b
                  WHERE b.forename = na.forename
                  AND b.surname = na.surname) 
and na.forename is not null
and na.surname is not null) x;


CREATE INDEX SGAS.ZMN_ST2 ON SGAS.zz_mask_nominee
(RECORD_NO)
COMPUTE STATISTICS;


DECLARE
        
   TYPE t_record_no_tab IS TABLE OF number;
   l_tab_record_no t_record_no_tab := t_record_no_tab();
   TYPE T_NOMINEE_TAB IS TABLE OF NOMINEE.NOMINEE_ID%TYPE;
   l_tab_nominee_id T_NOMINEE_TAB := T_NOMINEE_TAB();
   CURSOR c_nominee
   IS
         SELECT rownum record_no, S.NOMINEE_ID
          FROM NOMINEE S
      ORDER BY S.NOMINEE_ID;

BEGIN
   UPDATE zz_mask_nominee
      SET NOMINEE_ID = NULL;

    OPEN c_nominee;
    LOOP
    FETCH c_nominee BULK COLLECT INTO l_tab_record_no, l_tab_nominee_id LIMIT 1000;

    FORALL i IN l_tab_record_no.first .. l_tab_record_no.last

      UPDATE zz_mask_nominee S
         SET S.NOMINEE_ID = l_tab_nominee_id(i)
       WHERE S.RECORD_NO = l_tab_record_no(i);
                             
    EXIT WHEN c_nominee%NOTFOUND;
    END LOOP;
    CLOSE c_nominee;
      
   COMMIT;
END;

CREATE INDEX SGAS.ZMN_ST1 ON SGAS.zz_mask_nominee
(NOMINEE_ID)
COMPUTE STATISTICS;

DROP table zz_mask_stud_dependant_name;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_stud_dependant_name
AS
WITH c_stud
AS
(SELECT /*+ parallel(b,10) */ ROWNUM num_row, b.std_id, b.first_name,b.surname
FROM STUD_DEPENDANT b)
SELECT ROWNUM record_no, x.*,
       99999999 std_id
FROM (SELECT DISTINCT na.*
FROM (SELECT DISTINCT 
       LAG(n.first_name,2,'Scott') OVER(ORDER BY n.num_row) AS first_name,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT 
       LAG(n.first_name,6,'Scott') OVER(ORDER BY n.num_row) AS first_name,
       LAG(n.SURNAME,4,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT 
       LAG(n.first_name,8,'Scott') OVER(ORDER BY n.num_row) AS first_name,
       LAG(n.SURNAME,1,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT 
       LAG(n.first_name,2,'Scott') OVER(ORDER BY n.num_row) AS first_name,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n) na
WHERE NOT EXISTS (SELECT 1
                  FROM c_stud b
                  WHERE b.first_name = na.first_name
                  AND b.surname = na.surname) ) x;


CREATE INDEX SGAS.MSDN_ST2 ON SGAS.zz_mask_stud_dependant_name
(RECORD_NO)
COMPUTE STATISTICS;


DECLARE
        
   TYPE t_record_no_tab IS TABLE OF number;
   l_tab_record_no t_record_no_tab := t_record_no_tab();
   TYPE T_STUD_TAB IS TABLE OF STUD_DEPENDANT.STD_ID%TYPE;
   l_tab_stud_ref_no T_STUD_TAB := T_STUD_TAB();
   CURSOR C_STUD
   IS
         SELECT rownum record_no, S.std_id
          FROM STUD_DEPENDANT S
      ORDER BY S.std_id;
BEGIN
   UPDATE zz_mask_stud_dependant_name
      SET STD_ID = NULL;

    OPEN C_STUD;
    LOOP
    FETCH C_STUD BULK COLLECT INTO l_tab_record_no, l_tab_stud_ref_no LIMIT 1000;

    FORALL i IN l_tab_record_no.first .. l_tab_record_no.last

      UPDATE zz_mask_stud_dependant_name S
         SET S.STD_ID = l_tab_stud_ref_no(i)
       WHERE S.RECORD_NO = l_tab_record_no(i);
                             
    EXIT WHEN C_STUD%NOTFOUND;
    END LOOP;
    CLOSE C_STUD;
      
   COMMIT;
END;

CREATE INDEX SGAS.MSDN_ST1 ON SGAS.zz_mask_stud_dependant_name
(std_id)
COMPUTE STATISTICS;

DROP table zz_mask_benefactor;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_benefactor
AS
WITH c_benefactor
AS
(SELECT /*+ parallel(b,10) */ ROWNUM num_row, 
         NVL(b.BEN_ID, bw.BEN_ID) ben_id,
         NVL(B.TITLE, Bw.TITLE) title,
         NVL(B.INITIALS,BW.INITIALS) initials,
         NVL(b.forenames,bw.forenames) forenames,
         NVL(b.surname,bw.surname) surname,
         NVL(B.HOUSE_NO_NAME, bw.HOUSE_NO_NAME) HOUSE_NO_NAME,
         NVL(B.ADDR_L1, bw.ADDR_L1) ADDR_L1,
         NVL(B.ADDR_L2, bw.ADDR_L2) ADDR_L2,
         NVL(B.ADDR_L3, bw.ADDR_L3) ADDR_L3,
         NVL(B.ADDR_L4, bw.ADDR_L4) ADDR_L4,
         NVL(B.POST_CODE, bw.POST_CODE) POST_CODE
FROM benefactor b,
     benefactor_web bw,
     (select ben_id from benefactor union all select ben_id from benefactor_web) ab
where      ab.ben_id = b.ben_id(+)
and        ab.ben_id = bw.ben_id(+))
SELECT ROWNUM record_no, x.TITLE, x.INITIALS,
         x.forenames,x.surname,
         x.HOUSE_NO_NAME, x.ADDR_L1, x.ADDR_L2, x.ADDR_L3, x.ADDR_L4,
         x.POST_CODE,
       99999999 BEN_ID
FROM (SELECT DISTINCT na.*
FROM /* Formatted on 23/11/2016 13:59:20 (QP5 v5.256.13226.35538) */
(SELECT DISTINCT n.TITLE, n.INITIALS,
       LAG(n.forenames,1,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.HOUSE_NO_NAME,6,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,1,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,2,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,6,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_benefactor n
UNION
SELECT DISTINCT  n.TITLE, n.INITIALS,
       LAG(n.forenames,2,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,5,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.HOUSE_NO_NAME,6,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,5,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,2,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,1,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_benefactor n
UNION
SELECT DISTINCT  n.TITLE, n.INITIALS,
       LAG(n.forenames,3,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,8,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.HOUSE_NO_NAME,2,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,1,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,5,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,4,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,7,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_benefactor n
UNION
SELECT DISTINCT  n.TITLE, n.INITIALS,
       LAG(n.forenames,1,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,9,'Dummy') OVER(ORDER BY n.num_row) AS surname,
       LAG(n.HOUSE_NO_NAME,6,'Dummy') OVER(ORDER BY n.num_row) AS HOUSE_NO_NAME,
       LAG(n.ADDR_L1,5,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L1,
       LAG(n.ADDR_L2,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L2,
       LAG(n.ADDR_L3,3,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L3,
       LAG(n.ADDR_L4,7,'Dummy') OVER(ORDER BY n.num_row) AS ADDR_L4,
       LAG(n.POST_CODE,4,'Dummy') OVER(ORDER BY n.num_row) AS POST_CODE
FROM c_benefactor n) na
WHERE NOT EXISTS (SELECT 1
                  FROM c_benefactor b
                  WHERE b.forenames = na.forenames
                  AND b.surname = na.surname) 
and na.forenames is not null
and na.surname is not null) x;


CREATE INDEX SGAS.ZMB_ST2 ON SGAS.zz_mask_benefactor
(RECORD_NO)
COMPUTE STATISTICS;


DECLARE
        
   TYPE t_record_no_tab IS TABLE OF number;
   l_tab_record_no t_record_no_tab := t_record_no_tab();
   TYPE T_STUD_TAB IS TABLE OF BENEFACTOR.BEN_ID%TYPE;
   l_tab_ben_id T_STUD_TAB := T_STUD_TAB();
   CURSOR C_STUD
   IS
        select distinct rownum record_no, x.ben_id
        from (SELECT  ben_id FROM benefactor
        UNION ALL
        SELECT ben_id FROM benefactor_web) x
      ORDER BY 1;
BEGIN
   DELETE FROM zz_mask_benefactor
   WHERE RECORD_NO > (select COUNT(distinct x.ben_id) + 1000
                        from (SELECT  ben_id FROM benefactor
                        UNION ALL
                        SELECT ben_id FROM benefactor_web) x);
                        
   UPDATE zz_mask_benefactor
      SET BEN_ID = NULL;

    OPEN C_STUD;
    LOOP
    FETCH C_STUD BULK COLLECT INTO l_tab_record_no, l_tab_ben_id LIMIT 1000;

    FORALL i IN l_tab_record_no.first .. l_tab_record_no.last

      UPDATE zz_mask_benefactor S
         SET S.BEN_ID = l_tab_ben_id(i)
       WHERE S.RECORD_NO = l_tab_record_no(i);
                             
    EXIT WHEN C_STUD%NOTFOUND;
    END LOOP;
    CLOSE C_STUD;
      
   COMMIT;
END;


CREATE INDEX SGAS.ZMB_ST1 ON SGAS.zz_mask_benefactor
(BEN_ID)
COMPUTE STATISTICS;

DROP SEQUENCE SGAS.zz_mask_nino_seq;

CREATE SEQUENCE SGAS.zz_mask_nino_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999999
NOCACHE 
CYCLE 
NOORDER;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_BENEFACTOR'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_COLUMN'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_CONSTRAINT'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_INDEX'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_KEY'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_KEY_RESULT'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_NOMINEE'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_STUD_ADDRESS'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_STUD_DEPENDANT_NAME'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_STUD_NAME'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_TABLE'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


COMMIT;