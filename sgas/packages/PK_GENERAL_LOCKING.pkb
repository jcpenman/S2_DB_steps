CREATE OR REPLACE PACKAGE BODY SGAS.PK_GENERAL_LOCKING
AS
   FUNCTION get_employee_name (username_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR C_EMP
      IS
         SELECT E.FORENAME || ' ' || E.SURNAME
           FROM EMPLOYEE E
          WHERE E.USERNAME = username_in;

      V_EMP_NAME   VARCHAR2 (200);
   BEGIN
      OPEN C_EMP;

      FETCH C_EMP INTO V_EMP_NAME;

      CLOSE C_EMP;

      IF V_EMP_NAME IS NULL
      THEN
         V_EMP_NAME := username_in;
      END IF;

      RETURN V_EMP_NAME;
   END get_employee_name;


   PROCEDURE islocked (username_in         IN            VARCHAR2,
                       reference_type_in   IN            VARCHAR2,
                       reference_id_in     IN            VARCHAR2,
                       locked_status          OUT NOCOPY VARCHAR2,
                       locked_message         OUT NOCOPY VARCHAR2,
                       locked_by              OUT NOCOPY VARCHAR2)
   IS
      CURSOR C_LOCK
      IS
         SELECT 'TRUE' LOCKED_STATUS,
                   INITCAP (reference_type_in)
                || ' is locked by TERM DATES BATCH since '
                || TO_CHAR (GL.CREATED_DATE, 'hh24:MI DD/MM/YYYY')
                   LOCKED_MESSAGE,
                   GL.USERNAME LOCKED_BY
           FROM SGAS.GENERAL_LOCK GL
          WHERE GL.REFERENCE_TYPE = 'TERMDATES' AND GL.REFERENCE_ID = 'ALL'
         UNION ALL
         SELECT 'TRUE' LOCKED_STATUS,
                   INITCAP (reference_type_in)
                || ' is locked by '
                || get_employee_name (GL.USERNAME)
                || ' since '
                || TO_CHAR (GL.CREATED_DATE, 'hh24:MI DD/MM/YYYY')
                   LOCKED_MESSAGE,
                   GL.USERNAME LOCKED_BY
           FROM SGAS.GENERAL_LOCK GL
          WHERE     GL.REFERENCE_TYPE = reference_type_in
                AND GL.REFERENCE_ID = reference_id_in;
   BEGIN
      OPEN C_LOCK;

      FETCH C_LOCK INTO locked_status, locked_message, locked_by;

      CLOSE C_LOCK;

      IF locked_status IS NULL
      THEN
         locked_status := 'FALSE';
         locked_message := NULL;
      END IF;
   END islocked;



   PROCEDURE lockrecord (username_in         IN            VARCHAR2,
                         reference_type_in   IN            VARCHAR2,
                         reference_id_in     IN            VARCHAR2,
                         locked_status          OUT NOCOPY VARCHAR2,
                         locked_message         OUT NOCOPY VARCHAR2)
   IS
   v_locked_by VARCHAR2(15);
   BEGIN
      islocked (USERNAME_IN         => username_in,
                REFERENCE_TYPE_IN   => reference_type_in,
                REFERENCE_ID_IN     => reference_id_in,
                LOCKED_STATUS       => locked_status,
                LOCKED_MESSAGE      => locked_message,
                LOCKED_BY           => v_locked_by);

      IF locked_status = 'FALSE'
      THEN
         INSERT INTO SGAS.GENERAL_LOCK (USERNAME,
                                        REFERENCE_TYPE,
                                        REFERENCE_ID,
                                        LAST_MODIFIED_BY)
              VALUES (username_in,
                      reference_type_in,
                      reference_id_in,
                      username_in);

         islocked (USERNAME_IN         => username_in,
                   REFERENCE_TYPE_IN   => reference_type_in,
                   REFERENCE_ID_IN     => reference_id_in,
                   LOCKED_STATUS       => locked_status,
                   LOCKED_MESSAGE      => locked_message,
                   LOCKED_BY           => v_locked_by);
      ELSIF NVL(username_in,'x') = NVL(v_locked_by,'y')
      THEN  -- User already has the lock
        NULL;
      ELSE
         locked_status := 'FAILED';
      END IF;
   END lockrecord;

   PROCEDURE unlockrecord (username_in         IN            VARCHAR2,
                           reference_type_in   IN            VARCHAR2,
                           reference_id_in     IN            VARCHAR2,
                           locked_status          OUT NOCOPY VARCHAR2,
                           locked_message         OUT NOCOPY VARCHAR2)
   IS
    v_locked_by VARCHAR2(15);
   BEGIN
      UPDATE SGAS.GENERAL_LOCK GL
         SET GL.LAST_MODIFIED_BY = username_in
       WHERE  GL.USERNAME = CASE WHEN reference_id_in IS NULL THEN username_in ELSE GL.USERNAME END   
             AND GL.REFERENCE_TYPE = reference_type_in
             AND GL.REFERENCE_ID = NVL(reference_id_in, GL.REFERENCE_ID);

      DELETE FROM SGAS.GENERAL_LOCK GL
            WHERE  GL.USERNAME = CASE WHEN reference_id_in IS NULL THEN username_in ELSE GL.USERNAME END      
                  AND GL.REFERENCE_TYPE = reference_type_in
                  AND GL.REFERENCE_ID = NVL(reference_id_in, GL.REFERENCE_ID);

      islocked (USERNAME_IN         => username_in,
                REFERENCE_TYPE_IN   => reference_type_in,
                REFERENCE_ID_IN     => reference_id_in,
                LOCKED_STATUS       => locked_status,
                LOCKED_MESSAGE      => locked_message,
                LOCKED_BY           => v_locked_by);
   END unlockrecord;

   PROCEDURE unlockallrecords (username_in IN VARCHAR2)
   IS
   BEGIN
      UPDATE SGAS.GENERAL_LOCK GL
         SET GL.LAST_MODIFIED_BY = username_in;

      DELETE FROM SGAS.GENERAL_LOCK;
   END unlockallrecords;
END PK_GENERAL_LOCKING;
/