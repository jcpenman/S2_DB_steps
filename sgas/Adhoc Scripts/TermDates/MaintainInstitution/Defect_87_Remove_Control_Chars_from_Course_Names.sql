SELECT *
  FROM CRSE
 WHERE    INSTR (CRSE_NAME, CHR (1)) != 0
       OR INSTR (CRSE_NAME, CHR (2)) != 0
       OR INSTR (CRSE_NAME, CHR (3)) != 0
       OR INSTR (CRSE_NAME, CHR (4)) != 0
       OR INSTR (CRSE_NAME, CHR (5)) != 0
       OR INSTR (CRSE_NAME, CHR (6)) != 0
       OR INSTR (CRSE_NAME, CHR (7)) != 0
       OR INSTR (CRSE_NAME, CHR (8)) != 0
       OR INSTR (CRSE_NAME, CHR (9)) != 0
       OR INSTR (CRSE_NAME, CHR (10)) != 0
       OR INSTR (CRSE_NAME, CHR (11)) != 0
       OR INSTR (CRSE_NAME, CHR (12)) != 0
       OR INSTR (CRSE_NAME, CHR (13)) != 0
       OR INSTR (CRSE_NAME, CHR (14)) != 0
       OR INSTR (CRSE_NAME, CHR (15)) != 0
       OR INSTR (CRSE_NAME, CHR (16)) != 0
       OR INSTR (CRSE_NAME, CHR (17)) != 0
       OR INSTR (CRSE_NAME, CHR (18)) != 0
       OR INSTR (CRSE_NAME, CHR (19)) != 0
       OR INSTR (CRSE_NAME, CHR (20)) != 0
       OR INSTR (CRSE_NAME, CHR (21)) != 0
       OR INSTR (CRSE_NAME, CHR (22)) != 0
       OR INSTR (CRSE_NAME, CHR (23)) != 0
       OR INSTR (CRSE_NAME, CHR (24)) != 0
       OR INSTR (CRSE_NAME, CHR (25)) != 0
       OR INSTR (CRSE_NAME, CHR (26)) != 0
       OR INSTR (CRSE_NAME, CHR (27)) != 0
       OR INSTR (CRSE_NAME, CHR (28)) != 0
       OR INSTR (CRSE_NAME, CHR (29)) != 0
       OR INSTR (CRSE_NAME, CHR (30)) != 0
       OR INSTR (CRSE_NAME, CHR (31)) != 0;

UPDATE CRSE SET CRSE_NAME = REPLACE(REPLACE(CRSE.CRSE_NAME, CHR(1), ''), CHR(2), '')
WHERE CRSE_ID IN (
SELECT CRSE_ID
  FROM CRSE
 WHERE    INSTR (CRSE_NAME, CHR (1)) != 0
       OR INSTR (CRSE_NAME, CHR (2)) != 0
       OR INSTR (CRSE_NAME, CHR (3)) != 0
       OR INSTR (CRSE_NAME, CHR (4)) != 0
       OR INSTR (CRSE_NAME, CHR (5)) != 0
       OR INSTR (CRSE_NAME, CHR (6)) != 0
       OR INSTR (CRSE_NAME, CHR (7)) != 0
       OR INSTR (CRSE_NAME, CHR (8)) != 0
       OR INSTR (CRSE_NAME, CHR (9)) != 0
       OR INSTR (CRSE_NAME, CHR (10)) != 0
       OR INSTR (CRSE_NAME, CHR (11)) != 0
       OR INSTR (CRSE_NAME, CHR (12)) != 0
       OR INSTR (CRSE_NAME, CHR (13)) != 0
       OR INSTR (CRSE_NAME, CHR (14)) != 0
       OR INSTR (CRSE_NAME, CHR (15)) != 0
       OR INSTR (CRSE_NAME, CHR (16)) != 0
       OR INSTR (CRSE_NAME, CHR (17)) != 0
       OR INSTR (CRSE_NAME, CHR (18)) != 0
       OR INSTR (CRSE_NAME, CHR (19)) != 0
       OR INSTR (CRSE_NAME, CHR (20)) != 0
       OR INSTR (CRSE_NAME, CHR (21)) != 0
       OR INSTR (CRSE_NAME, CHR (22)) != 0
       OR INSTR (CRSE_NAME, CHR (23)) != 0
       OR INSTR (CRSE_NAME, CHR (24)) != 0
       OR INSTR (CRSE_NAME, CHR (25)) != 0
       OR INSTR (CRSE_NAME, CHR (26)) != 0
       OR INSTR (CRSE_NAME, CHR (27)) != 0
       OR INSTR (CRSE_NAME, CHR (28)) != 0
       OR INSTR (CRSE_NAME, CHR (29)) != 0
       OR INSTR (CRSE_NAME, CHR (30)) != 0
       OR INSTR (CRSE_NAME, CHR (31)) != 0
       );