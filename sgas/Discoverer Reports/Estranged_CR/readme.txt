Run the Estranged Discoverer Report scripts in the following order:

01 REPORTING TABLE --> ESTRANGED_STUD_REPORT.sql
02 VIEW FOR AWARDS --> V_AWARDS_REPORT.sql
03 VIEW FOR REPORT --> V_ESTRANGED_STUD_REPORT.sql
04 PL/SQL PACKAGE ---> PK_STEPS_ESTRANGED_STUD_REPORT.pks
05 PL/SQL PACKAGE ---> PK_STEPS_ESTRANGED_STUD_REPORT.pkb
06 DATABASE JOB -----> ESTRANGED_STUD_REPORT_JOB.sql



The drop script below rolls back the changes applied in the scripts above.

00 DROP_SCRIPTS.sql