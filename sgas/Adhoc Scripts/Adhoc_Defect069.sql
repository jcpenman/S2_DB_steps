-- Fix for Defect 069 to modify default value for column 'OUT_UK' in table 'STUD_HOME_ADDR' to value 'N'.
ALTER TABLE SGAS.STUD_HOME_ADDR MODIFY (OUT_UK DEFAULT 'N');