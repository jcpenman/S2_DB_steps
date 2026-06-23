/* 

Author      Version     Date
======      =======     ==== 
R Hunter    0.1         30 April 2009

DROP_RDNT_TABLES.sql

Script to remove redundant tables from STEPS SGAS schema

*/
DROP TABLE
edm_temp_copy;
DROP TABLE
edm_complete_copy;
DROP TABLE
raw_data_copy;
DROP TABLE
test_cases_edm_complete;
DROP TABLE
system_test_cases_raw_data;
DROP TABLE
system_test_cases_edm_temp;
COMMIT ;