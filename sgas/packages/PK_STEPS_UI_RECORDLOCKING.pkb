CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_recordlocking
AS
   PROCEDURE islocked (reference_id_in IN VARCHAR2, islocked OUT NOCOPY NUMBER)
   IS
      v_locked   NUMBER (1);
   BEGIN
      SELECT COUNT (el.reference_id) AS islocked
        INTO v_locked
        FROM employee_locks el
       WHERE UPPER (el.reference_id) = UPPER (reference_id_in);

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
      SELECT COUNT (el.reference_id) AS isexpired
        INTO v_expired
        FROM employee_locks el
       WHERE UPPER (el.reference_id) = UPPER (reference_id_in)
             AND ttl < SYSDATE;

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
      SELECT COUNT (el.reference_id) AS isowned
        INTO v_owned
        FROM employee_locks el
       WHERE el.reference_id = reference_id_in
         AND UPPER (el.username) = UPPER (employee_in);

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
      SELECT el.username
        INTO owner_out
        FROM employee_locks el
       WHERE UPPER (el.reference_id) = UPPER (reference_id_in);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         owner_out := 'NO OWNER';
   END getowner;

   PROCEDURE lockrecord (
      reference_id_in        IN   VARCHAR2,
      employee_in            IN   VARCHAR2,
      reference_id_type_in   IN   VARCHAR2
   )
   IS
      v_date   DATE;
   BEGIN
      v_date := SYSDATE + (240 / 1440);

      INSERT INTO employee_locks el
                  (el.reference_id, el.username, el.ttl,
                   el.reference_type_id
                  )
           VALUES (reference_id_in, UPPER (employee_in), v_date,
                   reference_id_type_in
                  );

      COMMIT;
      EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END lockrecord;

   PROCEDURE unlockallrecords (employee_in IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM employee_locks el
            WHERE UPPER (el.username) = UPPER (employee_in);
      COMMIT;
      EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END unlockallrecords;

   PROCEDURE unlockrecord (reference_id_in IN VARCHAR2, employee_in IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM employee_locks el
            WHERE UPPER (el.reference_id) = UPPER (reference_id_in)
              AND UPPER (el.username) = UPPER (employee_in);
      COMMIT;
      EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END unlockrecord;

   PROCEDURE updatettl (reference_id_in IN VARCHAR2)
   IS
      v_date   DATE;
   BEGIN
      v_date := SYSDATE + (240 / 1440);

      UPDATE employee_locks el
         SET ttl = v_date
       WHERE UPPER (el.reference_id) = UPPER (reference_id_in);

      COMMIT;
      EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END updatettl;
END pk_steps_ui_recordlocking;
/