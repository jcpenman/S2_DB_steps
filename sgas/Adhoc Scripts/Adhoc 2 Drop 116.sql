INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'K', 'Civil Parntership'
            );
            
ALTER TABLE SGAS.STUD DROP CONSTRAINT ST_MARITAL_STATUS;            
            
ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_MARITAL_STATUS
 CHECK ( MARITAL_STATUS IN('S','M','D','P','W','E','K')));



