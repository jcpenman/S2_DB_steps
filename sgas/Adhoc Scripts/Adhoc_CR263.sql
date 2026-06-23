-- CR263 add a column (PLUS_ONE_USED) to student table (STUD) to indicate whether or not the student has made use of their 'plus one'.
ALTER TABLE SGAS.STUD
 ADD PLUS_ONE_USED VARCHAR2(1);

-- CR263 add a constraint to column added above (PLUS_ONE_USED) to ensure values can only be set to 'Y', 'N' or left as NULL.
ALTER TABLE SGAS.STUD ADD (
 CONSTRAINT ST_PLUS_ONE_USED
 CHECK (PLUS_ONE_USED IN('Y', 'N', NULL)));
 
COMMIT;