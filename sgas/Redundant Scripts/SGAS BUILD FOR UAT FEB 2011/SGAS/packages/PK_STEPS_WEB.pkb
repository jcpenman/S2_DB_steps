CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_web
IS
-- DESCRIPTION
-- ===========
-- Package contains any StePS/WEB related procedures
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 09.07.2009          A.Bowman    001    Initial Creation of Package
-- 04.03.2010          A.Bowman    002    Proc Update_Web_Indicator no longer req'd this is now handled by pk_web_steps.auth_steps_students
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE authenticate_student (
      p_stud_ref_no         NUMBER,
      p_web_user_id         VARCHAR2,
      error_message   OUT   VARCHAR2
   )
/******************************************************************************
NAME:       AUTHENTICATE_STUDENT
PURPOSE:    To carry out the authentication process for StEPS students
             to use web services.

Version    Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        14/07/2009  Adrian Bowman    1. Initial Creation of proc
******************************************************************************/
   IS
      lv_user_exists   VARCHAR2 (1);
      lv_stud_exists   VARCHAR2 (1);
      lv_web_user_id   authenticate_stud.web_user_id%TYPE;
      lv_stud_ref_no   authenticate_stud.stud_ref_no%TYPE;

      CURSOR c_web_user_id
      IS
         SELECT web_user_id
           FROM authenticate_stud
          WHERE web_user_id = p_web_user_id;

      CURSOR c_stud_ref_no
      IS
         SELECT stud_ref_no
           FROM authenticate_stud
          WHERE stud_ref_no = p_stud_ref_no;
   BEGIN
      OPEN c_web_user_id;

      FETCH c_web_user_id
       INTO lv_web_user_id;

      CLOSE c_web_user_id;

      OPEN c_stud_ref_no;

      FETCH c_stud_ref_no
       INTO lv_stud_ref_no;

      CLOSE c_stud_ref_no;

      IF lv_web_user_id IS NOT NULL
      THEN
         lv_user_exists := 'Y';
      ELSE
         lv_user_exists := 'N';
      END IF;

      IF lv_stud_ref_no IS NOT NULL
      THEN
         lv_stud_exists := 'Y';
      ELSE
         lv_stud_exists := 'N';
      END IF;

      /* IF lv_user_exists = 'Y' AND lv_stud_exists = 'Y'
       THEN
          DELETE FROM authenticate_stud
                WHERE web_user_id = p_web_user_id
                  AND stud_ref_no = p_stud_ref_no;

          RETURN;
       END IF;*/ -- Deletions from authenticate_stud are handled by PK_WEB_STEPS
      IF lv_user_exists = 'N' AND lv_stud_exists = 'N'
      THEN
         INSERT INTO authenticate_stud
                     (stud_ref_no, web_user_id
                     )
              VALUES (p_stud_ref_no, p_web_user_id
                     );
      ELSIF lv_user_exists = 'N' AND lv_stud_exists = 'Y'
      THEN
         UPDATE authenticate_stud
            SET web_user_id = p_web_user_id
          WHERE stud_ref_no = p_stud_ref_no;
      ELSIF lv_user_exists = 'Y' AND lv_stud_exists = 'N'
      THEN
         INSERT INTO authenticate_stud
                     (stud_ref_no, web_user_id
                     )
              VALUES (p_stud_ref_no, p_web_user_id
                     );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_message := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END authenticate_student;


   PROCEDURE dla_requests (error_message OUT VARCHAR2)
/******************************************************************************
NAME:       DLA_REQUESTS
PURPOSE:    To process web requests for duplicate letter of awards

Version    Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        15/07/2009  Adrian Bowman    1. Initial Creation of proc
******************************************************************************/
   IS
      CURSOR c_dla_request
      IS
         SELECT a.date_requested, b.sal_sent_date, a.stud_crse_year_id
           FROM dla_request a, stud_crse_year b
          WHERE a.stud_crse_year_id = b.stud_crse_year_id;

      v_dla_req   c_dla_request%ROWTYPE;
   BEGIN
      INSERT INTO dla_request
         (SELECT *
            FROM dla_requests@web);

      OPEN c_dla_request;

      LOOP
         FETCH c_dla_request
          INTO v_dla_req;

         EXIT WHEN c_dla_request%NOTFOUND;

         IF v_dla_req.date_requested > v_dla_req.sal_sent_date
         THEN
            UPDATE stud_crse_year b
               SET b.sal_sent = 'N',
                   b.req_dup = 'Y'
             WHERE v_dla_req.stud_crse_year_id = b.stud_crse_year_id;
         END IF;
      END LOOP;

      CLOSE c_dla_request;

      DELETE FROM dla_request;

      DELETE FROM dla_requests@web;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_message := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;
   END dla_requests;

   PROCEDURE password_letter_requests (error_message OUT VARCHAR2)
   IS
/******************************************************************************
NAME:       PASSWORD_LETTER_REQUESTS
PURPOSE:    To process web requests for password letters

Version    Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        05/03/2010  Adrian Bowman    1. Initial Creation of proc
******************************************************************************/
   BEGIN
      INSERT INTO password_letter_request
         (SELECT *
            FROM password_letter_request@web);

      DELETE FROM password_letter_request@web;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_message := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;
   END password_letter_requests;


END pk_steps_web;
/

grant execute on pk_steps_web to public;