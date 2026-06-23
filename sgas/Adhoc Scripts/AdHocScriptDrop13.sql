ALTER TABLE SGAS.stud_crse_year
 ADD non_erasmus_exchange varchar2(1 BYTE) Default 'N';
 
ALTER TABLE SGAS.stud_crse_year ADD (
  CONSTRAINT stcy_non_era_ex
 CHECK (non_erasmus_exchange in ('Y','N')));
 
ALTER TABLE SGAS.stud
 ADD residence_status varchar2(1);