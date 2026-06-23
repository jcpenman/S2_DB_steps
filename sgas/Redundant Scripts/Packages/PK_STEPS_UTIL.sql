CREATE OR REPLACE PACKAGE sgas.pk_steps_util
IS
/*
pk_StEPS_util.ben_id to generate the next ben_id for benefactors.
R HUNTER 09/03/2009
*/
   FUNCTION ben_id
      RETURN NUMBER;

/*
pk_StEPS_util.stud_session_id to generate the next session_id for stud sessions.
R HUNTER 09/03/2009
*/
   FUNCTION stud_session_id
      RETURN NUMBER;
END pk_steps_util;
/

CREATE OR REPLACE PACKAGE BODY pk_steps_util
IS
   FUNCTION ben_id
      RETURN NUMBER
   AS
      retval   NUMBER;
   BEGIN
/*
pk_StEPS_util.ben_id to generate the next ben_id for benefactors.
R HUNTER 09/03/2009
*/
      SELECT be_ben_id_seq.NEXTVAL
        INTO retval
        FROM DUAL;

      RETURN (retval);
   END ben_id;

   FUNCTION stud_session_id
      RETURN NUMBER
   AS
      retval   NUMBER;
   BEGIN
/*
pk_StEPS_util.stud_session_id to generate the next stud_session_id for stud sessions
R HUNTER 09/03/2009
*/
      SELECT sts_stud_session_id_seq.NEXTVAL
        INTO retval
        FROM DUAL;

      RETURN (retval);
   END stud_session_id;
END pk_steps_util;
/

CREATE PUBLIC SYNONYM pk_steps_util FOR sgas.pk_steps_util
/
GRANT EXECUTE ON sgas.pk_steps_util TO PUBLIC
/