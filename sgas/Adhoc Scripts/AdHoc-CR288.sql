-- CR288-----
ALTER TABLE inst_cont_details MODIFY securezip_password VARCHAR2(14);  
-- Append "!4" to column values
UPDATE inst_cont_details SET securezip_password = securezip_password||'!4';