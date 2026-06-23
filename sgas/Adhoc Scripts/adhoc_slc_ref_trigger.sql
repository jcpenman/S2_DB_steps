-- Amended trigger for SLC_REF_NO on the Stud table
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.04.2010  A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

CREATE OR REPLACE TRIGGER sgas.trig_st_slc_ref_no_seq
   BEFORE INSERT
   ON sgas.stud
   FOR EACH ROW
DECLARE
   slc               NUMBER;
   dig1              NUMBER;
   dig2              NUMBER;
   dig3              NUMBER;
   dig4              NUMBER;
   dig5              NUMBER;
   dig6              NUMBER;
   dig7              NUMBER;
   dig8              NUMBER;
   dig9              NUMBER;
   dig10             NUMBER;
   dig11             NUMBER;
   dig12             NUMBER;
   l_total           NUMBER;
   l_rem             NUMBER;
   l_diff            NUMBER;
   l_sess            VARCHAR2 (4);
   slcno             VARCHAR2 (10);
   chk_dig           VARCHAR2 (1);
   p_scottish_cand   stud.scottish_cand%TYPE   := :NEW.scottish_cand;
BEGIN
   IF p_scottish_cand IS NULL
   THEN
      SELECT st_slc_ref_no_seq.NEXTVAL
        INTO slc
        FROM DUAL;

      SELECT SUBSTR (cval, 3, 2)
        INTO l_sess
        FROM config_data
       WHERE item_name = 'CURRENT_SESSION';

      slcno :=
              LTRIM (RTRIM (l_sess))
              || LTRIM (RTRIM (TO_CHAR (slc, '000000')));
      --
      dig1 := 16 * 13;
      dig2 := 1 * 12;
      dig3 := 1 * 11;
      dig4 := 16 * 10;
      dig5 := TO_NUMBER (SUBSTR (l_sess, 1, 1)) * 9;
      dig6 := TO_NUMBER (SUBSTR (l_sess, 2, 1)) * 8;
      dig7 := TO_NUMBER (SUBSTR (slcno, 3, 1)) * 7;
      dig8 := TO_NUMBER (SUBSTR (slcno, 4, 1)) * 6;
      dig9 := TO_NUMBER (SUBSTR (slcno, 5, 1)) * 5;
      dig10 := TO_NUMBER (SUBSTR (slcno, 6, 1)) * 4;
      dig11 := TO_NUMBER (SUBSTR (slcno, 7, 1)) * 3;
      dig12 := TO_NUMBER (SUBSTR (slcno, 8, 1)) * 2;
      --
      l_total :=
           dig1
         + dig2
         + dig3
         + dig4
         + dig5
         + dig6
         + dig7
         + dig8
         + dig9
         + dig10
         + dig11
         + dig12;

      --
      SELECT MOD (l_total, 23)
        INTO l_rem
        FROM DUAL;

      --
      l_diff := 23 - l_rem;

      --
      IF l_diff = 1
      THEN
         chk_dig := 'A';
      ELSIF l_diff = 2
      THEN
         chk_dig := 'B';
      ELSIF l_diff = 3
      THEN
         chk_dig := 'C';
      ELSIF l_diff = 4
      THEN
         chk_dig := 'D';
      ELSIF l_diff = 5
      THEN
         chk_dig := 'E';
      ELSIF l_diff = 6
      THEN
         chk_dig := 'F';
      ELSIF l_diff = 7
      THEN
         chk_dig := 'G';
      ELSIF l_diff = 8
      THEN
         chk_dig := 'H';
      ELSIF l_diff = 9
      THEN
         chk_dig := 'J';
      ELSIF l_diff = 10
      THEN
         chk_dig := 'K';
      ELSIF l_diff = 11
      THEN
         chk_dig := 'L';
      ELSIF l_diff = 12
      THEN
         chk_dig := 'M';
      ELSIF l_diff = 13
      THEN
         chk_dig := 'N';
      ELSIF l_diff = 14
      THEN
         chk_dig := 'P';
      ELSIF l_diff = 15
      THEN
         chk_dig := 'R';
      ELSIF l_diff = 16
      THEN
         chk_dig := 'S';
      ELSIF l_diff = 17
      THEN
         chk_dig := 'T';
      ELSIF l_diff = 18
      THEN
         chk_dig := 'U';
      ELSIF l_diff = 19
      THEN
         chk_dig := 'V';
      ELSIF l_diff = 20
      THEN
         chk_dig := 'W';
      ELSIF l_diff = 21
      THEN
         chk_dig := 'X';
      ELSIF l_diff = 22
      THEN
         chk_dig := 'Y';
      ELSIF l_diff = 23
      THEN
         chk_dig := 'Z';
      END IF;

      --
      slcno := slcno || chk_dig;

      SELECT slcno
        INTO :NEW.scottish_cand
        FROM DUAL;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000,
                               'SLC_REF_NO ERROR: ' || SQLERRM || SQLCODE
                              );
END trig_st_slc_ref_no_seq;
/
