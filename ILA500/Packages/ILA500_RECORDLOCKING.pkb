CREATE OR REPLACE PACKAGE BODY ILA500.ila500_recordlocking
AS
   PROCEDURE islocked (reference_id_in IN VARCHAR2, islocked OUT NOCOPY NUMBER)
   IS
      v_locked   NUMBER (1);
   BEGIN
      SELECT COUNT (reference_id) AS islocked
        INTO v_locked
        FROM ila500_caseworker_locks
       WHERE UPPER (reference_id) = UPPER (reference_id_in);

      IF v_locked = 0
      THEN
         islocked := 0;
      ELSE
         islocked := 1;
      END IF;
   END islocked;

   PROCEDURE isexpired (
      reference_id_in   IN              VARCHAR2,
      isexpired         OUT NOCOPY      NUMBER
   )
   IS
      v_expired   NUMBER (1);
   BEGIN
      SELECT COUNT (reference_id) AS isexpired
        INTO v_expired
        FROM ila500_caseworker_locks
       WHERE UPPER (reference_id) = UPPER (reference_id_in) AND ttl < SYSDATE;

      IF v_expired = 0
      THEN
         isexpired := 0;
      ELSE
         isexpired := 1;
      END IF;
   END isexpired;

   PROCEDURE isowned (
      reference_id_in   IN              VARCHAR2,
      employee_in       IN              VARCHAR2,
      isowned           OUT NOCOPY      NUMBER
   )
   IS
      v_owned   NUMBER (1);
   BEGIN
      SELECT COUNT (reference_id) AS isowned
        INTO v_owned
        FROM ila500_caseworker_locks
       WHERE reference_id = reference_id_in
         AND UPPER (caseworker_id) = UPPER (employee_in);

      IF v_owned = 0
      THEN
         isowned := 0;
      ELSE
         isowned := 1;
      END IF;
   END isowned;

   PROCEDURE getowner (
      reference_id_in   IN              VARCHAR2,
      owner_out         OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT caseworker_id
        INTO owner_out
        FROM ila500_caseworker_locks
       WHERE UPPER (reference_id) = UPPER (reference_id_in);
       
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
       owner_out := 'NO OWNER';
   END getowner;

   PROCEDURE lockrecord (
      reference_id_in    IN   VARCHAR2,
      employee_in        IN   VARCHAR2,
      reference_id_type_in   IN   VARCHAR2
   )
   IS
      v_date   DATE;
   BEGIN
      v_date := SYSDATE + (30 / 1440);

      INSERT INTO ila500_caseworker_locks
                  (reference_id, caseworker_id, ttl,
                   reference_id_type
                  )
           VALUES (reference_id_in, UPPER (employee_in), v_date,
                   reference_id_type_in
                  );
   END lockrecord;

   PROCEDURE unlockallrecords (employee_in IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM ila500_caseworker_locks
              WHERE UPPER (employee_in) = UPPER (caseworker_id);
   END unlockallrecords;

   PROCEDURE unlockrecord (reference_id_in IN VARCHAR2, employee_in IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM ila500_caseworker_locks
            WHERE UPPER (reference_id) = UPPER (reference_id_in)
              AND UPPER (employee_in) = UPPER (caseworker_id);
   END unlockrecord;

   PROCEDURE updatettl (reference_id_in IN VARCHAR2)
   IS
      v_date   DATE;
   BEGIN
      v_date := SYSDATE + (30 / 1440);

      UPDATE ila500_caseworker_locks
         SET ttl = v_date
       WHERE UPPER (reference_id) = UPPER (reference_id_in);
   END updatettl;
END ila500_recordlocking;
/
