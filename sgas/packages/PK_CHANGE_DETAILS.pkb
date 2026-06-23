CREATE OR REPLACE PACKAGE BODY SGAS.pk_change_details
IS
    /*
    * Set-up logging file
    */
    logfile_out       UTL_FILE.file_type := NULL;
    log_dir           VARCHAR2 (200);
    v_logfile         VARCHAR2 (50);
    /*DBMS_OUTPUT   .ENABLE;
      log_dir := '/projects/app/steps/logs/change_of_details';
      sql_txt := 'SELECT TO_CHAR(sysdate, ''yyyymmdd'') FROM DUAL';
      EXECUTE IMMEDIATE sql_txt INTO v_logfile;
      logfile_out := --UTL_FILE.fopen (log_dir, v_logfile || '.log', 'A');
    */
    PROCEDURE pull_web_changes
    IS
      /*
       * Procedure picks up all web changesevery minute
       * and updates the STEPS database. Procedure is called by
       * dbms job on the steps database
       *
       *   Author                   Date                        Change
       *  --------                --------                  -------------
       * Clark Bolan             06/02/2014          CR 239 and defect 83 (StEPS_Defects)
       *                                             update SLC sent flags when loan details
       *                                             change
       * Ewan Watson             08/10/2015          OLS 2016 Updates
       * 
       *
       * Mike Tolmie            28/02/2019          CR OLS-86 Update
       *


       *
       *Clark Bolan            26/08/2021           PTFG Online Changes
       */

    
    
    v_change_date     DATE := NULL;
    v_stud_ref        sgas.stud.stud_ref_no%TYPE := NULL;
    v_user_id         VARCHAR2(25) := NULL;
    v_return_string   VARCHAR2 (1000) := NULL;
    v_change_type     VARCHAR2 (1000) := NULL;
    
    CURSOR web_changes_cur
    IS
        SELECT stud_ref_no, TRUNC (change_date),  'MAIL', user_id
          FROM email_change@web a 
          --   WHERE change_date >= TRUNC (SYSDATE)
         --WHERE user_id IS NOT NULL
           WHERE change_date = (SELECT MAX (change_date) /* most recent change*/
                               FROM email_change@web b
                              WHERE a.stud_ref_no = b.stud_ref_no)
        UNION
        SELECT stud_ref_no, TRUNC (change_date), 'PHONE', user_id
          FROM phone_change@web a                   
          --   WHERE change_date >= TRUNC (SYSDATE)
         WHERE user_id IS NOT NULL
           AND change_date = (SELECT MAX (change_date) /* most recent change*/
                                FROM phone_change@web b

                               WHERE a.user_id = b.user_id)
        UNION
        SELECT stud_ref_no, TRUNC (change_date), 'TERM', NULL
          FROM term_addr_change@web a
          --   WHERE change_date >= TRUNC (SYSDATE)
         WHERE stud_ref_no IS NOT NULL
           AND change_date = (SELECT MAX (change_date)
                                FROM term_addr_change@web b
                               WHERE a.stud_ref_no = b.stud_ref_no)
        UNION
        SELECT stud_ref_no, TRUNC (change_date), 'HOME', user_id
          FROM home_addr_change@web a
          --   WHERE change_date >= TRUNC (SYSDATE)
         WHERE user_id IS NOT NULL
           AND change_date = (SELECT MAX (change_date)
                                FROM home_addr_change@web b

                               WHERE a.user_id = b.user_id)
        UNION
        SELECT stud_ref_no, TRUNC (change_date), 'BANK', NULL
          FROM bank_change@web a
          --    WHERE change_date >= TRUNC (SYSDATE)
         WHERE stud_ref_no IS NOT NULL
           AND change_date = (SELECT MAX (change_date)
                                FROM bank_change@web b
                               WHERE a.stud_ref_no = b.stud_ref_no)
        UNION
        SELECT stud_ref_no, TRUNC (change_date),  'LOAN', NULL
          FROM loan_contacts_change@web a
          --    WHERE change_date >= TRUNC (SYSDATE)
         WHERE stud_ref_no IS NOT NULL
           AND change_date = (SELECT MAX (change_date)
                                FROM loan_contacts_change@web b
                               WHERE a.stud_ref_no = b.stud_ref_no)
        UNION
        SELECT stud_ref_no, TRUNC (change_date), 'PERSONAL', NULL
          FROM stud_change@web a          
          --    WHERE change_date >= TRUNC (SYSDATE)
         WHERE stud_ref_no IS NOT NULL
           AND change_date = (SELECT MAX (change_date)
                                FROM stud_change@web b
                               WHERE a.stud_ref_no = b.stud_ref_no)
        UNION
        SELECT stud_ref_no, TRUNC (change_date) change_date, 'COURSE', NULL
          FROM course_change@web a   
          WHERE a.DATE_TRANSFER_TO_STEPS is null;                              
    
        lnum                   NUMBER := 0;
        v_sqlcode         sgas.pull_web_exc.SQLCODE%TYPE := SQLCODE;
        v_sqlerrm         sgas.pull_web_exc.SQLERRM%TYPE := SQLERRM;
    
    BEGIN
        DBMS_OUTPUT.put_line ('in web_changes');
        OPEN web_changes_cur;

        LOOP
            lnum := lnum + 1;
            DBMS_OUTPUT.put_line ('LOOP NO ' || lnum);
            
            FETCH web_changes_cur
            INTO v_stud_ref, v_change_date, v_change_type, v_user_id;           

            EXIT WHEN web_changes_cur%NOTFOUND;

            --UTL_FILE.put_line (logfile_out, 'STEPS');
            --UTL_FILE.put_line (logfile_out, 'calling steps steps_change_of_details');
            DBMS_OUTPUT.put_line ('calling steps steps_change_of_details');
            steps_change_of_details (v_stud_ref,
                                     v_user_id,
                                     v_change_date,
                                     v_change_type,
                                     v_return_string
                                    );
         
            --UTL_FILE.put_line (logfile_out, 'return string' || v_return_string);
            DBMS_OUTPUT.put_line ('return string' || v_return_string);
        END LOOP;

        --CR OLS-86 Remove delete from course change
        
        CLOSE web_changes_cur;
                
        COMMIT;
    EXCEPTION
      WHEN OTHERS
      THEN
         CLOSE web_changes_cur;

         ROLLBACK;

         INSERT INTO sgas.pull_web_exc
                     (change_date, SQLCODE, SQLERRM
                     )
              VALUES (SYSDATE, v_sqlcode, v_sqlerrm
                     );

        COMMIT;
    END pull_web_changes;


    PROCEDURE steps_change_of_details (p_stud_ref        IN     NUMBER,
                                       p_user_id         IN     VARCHAR2, 
                                       p_change_date     IN     DATE,
                                       p_change_type     IN     VARCHAR2,
                                       p_return_string   OUT    VARCHAR2)
    IS
        v_display_date   VARCHAR2 (1000);
    BEGIN
         
        --UTL_FILE.put_line (logfile_out, 'in the function=' || p_change_type || '=');
        --UTL_FILE.put_line (logfile_out, p_stud_ref || p_change_date || p_change_type);
        DBMS_OUTPUT.put_line ('in the function=' || p_change_type || '=');
        DBMS_OUTPUT.put_line (p_stud_ref || p_change_date || p_change_type);

        CASE p_change_type
            WHEN 'BANK'
            THEN
                steps_bank_change (p_stud_ref, p_change_date);
                
            WHEN 'HOME'
            THEN
                steps_home_change (p_stud_ref, p_change_date, p_user_id);
                
            WHEN 'LOAN'
            THEN
                steps_loan_change (p_stud_ref, p_change_date);
                
            WHEN 'MAIL'
            THEN
                steps_mail_change (p_stud_ref, p_change_date, p_user_id);
                
            WHEN 'PHONE'
            THEN
                steps_phone_change (p_stud_ref, p_change_date, p_user_id);
                
            WHEN 'PERSONAL'
            THEN
                steps_personal_change (p_stud_ref, p_change_date);
                
            WHEN 'TERM'
            THEN
                steps_term_change (p_stud_ref, p_change_date);
                
            WHEN 'COURSE'
            THEN
                steps_course_change (p_stud_ref, p_change_date);

            ELSE
                p_return_string := 'INVALID CHANGE TYPE';
        END CASE;

        p_return_string := 'NO ERROR';
    EXCEPTION
        WHEN OTHERS
        THEN
            --UTL_FILE.put_line (logfile_out, SQLCODE || SQLERRM);
            DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
    END steps_change_of_details;



    PROCEDURE steps_bank_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
    IS
        CURSOR bank_cur
        IS
            SELECT account_no, sort_code, bank_validate
              FROM bank_change@web
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;
        
        v_account_no      stud.account_no%TYPE := NULL;
        v_sort_code       stud.sort_code%TYPE := NULL;
        v_bank_validate   stud.bank_validate%TYPE := NULL;
        v_sqlcode         bank_change_exc.SQLCODE%TYPE := SQLCODE;
        v_sqlerrm         bank_change_exc.SQLERRM%TYPE := SQLERRM;
        v_sql_err_1       VARCHAR2 (25) := NULL;
        v_sql_err_2       VARCHAR2 (100) := NULL;

    BEGIN
        DBMS_OUTPUT.put_line ('- in steps_bank_change');
        OPEN bank_cur;
        
        FETCH bank_cur
        INTO v_account_no, v_sort_code, v_bank_validate; 
    
        IF v_account_no IS NOT NULL AND v_sort_code IS NOT NULL
        THEN
            DBMS_OUTPUT.put_line ('- in steps_bank_change about to update ' || v_account_no || ' ' || v_sort_code );
            UPDATE stud
               SET payment_method = 'B', 
                   account_no = v_account_no,
                   sort_code = v_sort_code,
                   bank_validate = v_bank_validate,
                   last_updated_by = USER,
                   last_updated_on = SYSDATE
             WHERE stud_ref_no = p_stud_ref;
            
            /*Set SAL_SENT to N sends award letter with new bank details */
            UPDATE stud_crse_year
               SET sal_sent = 'N'
             WHERE     stud_ref_no = p_stud_ref
                   AND latest_crse_ind = 'Y'
                   AND session_code IN (SELECT cval
                                          FROM config_data
                                         WHERE item_name = 'CURRENT_SESSION');
        END IF;
        CLOSE bank_cur;

        /* Delete the interface data only where the stud ref no exists*/
    
        DELETE FROM bank_change@web
        WHERE stud_ref_no = p_stud_ref;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
        ROLLBACK;
        INSERT INTO sgas.bank_change_exc
                    (stud_ref_no, change_date, account_no, sort_code, 
                     SQLCODE, SQLERRM)
             VALUES (p_stud_ref, p_change_date, v_account_no, v_sort_code,
                     v_sql_err_1, v_sql_err_2);

        COMMIT;
    END steps_bank_change;


    PROCEDURE steps_mail_change (p_stud_ref IN NUMBER, p_change_date IN DATE, p_user_id VARCHAR2)
    IS
    
    
         CURSOR mail_cur
            IS
        SELECT email_addr, user_id
          FROM email_change@web


         WHERE stud_ref_no = p_stud_ref AND TRUNC (change_date) = p_change_date;
         
         CURSOR mail_cur_ptfg
            IS
        SELECT email_addr, user_id
          FROM email_change@web
         WHERE stud_ref_no = p_stud_ref AND TRUNC (change_date) = p_change_date;
    
        v_pt_and_ft   BOOLEAN := NULL;     
        v_new_email   stud.email_addr%TYPE := NULL;
        v_user_id     VARCHAR(25) := NULL;  
        v_sqlcode     email_change_exc.SQLCODE%TYPE := SQLCODE;
        v_sqlerrm     email_change_exc.SQLERRM%TYPE := SQLERRM;
        v_sql_err_1   VARCHAR2 (25) := NULL;
        v_sql_err_2   VARCHAR2 (100) := NULL;
        l_stud_type   VARCHAR2(10) := NULL;
        v_stud_ref_no NUMBER(10) := NULL;  
        v_learner_id  NUMBER(10) := NULL;    


    BEGIN
         DBMS_OUTPUT.put_line ('- in steps_mail_change TOP UNDER BEGIN ');
    
        IF (p_user_id != NULL OR p_user_id = '')
            THEN
            DBMS_OUTPUT.put_line ('- in steps_mail_change IN IF p_user_id <> NULL  ');
                v_pt_and_ft := part_time_and_full_time(p_user_id);
                l_stud_type := part_time_or_full_time(p_user_id);
            
            DBMS_OUTPUT.put_line ('- in steps_mail_change');
            IF v_pt_and_ft = FALSE
            THEN
                IF l_stud_type = 'STEPS_ONLY'
                THEN
                
                OPEN mail_cur;
                FETCH mail_cur 
                INTO v_new_email, v_user_id;       
                
                IF v_new_email IS NOT NULL
                THEN
                
                    UPDATE stud
                       SET email_addr = v_new_email,
                           last_updated_by = 'SGAS',
                           last_updated_on = SYSDATE
                     WHERE stud_ref_no = p_stud_ref;
                     
                     CLOSE mail_cur;
                END IF; 
                
                ELSIF l_stud_type = 'PTFG_ONLY'
                THEN
                
                OPEN mail_cur_ptfg;
                FETCH mail_cur_ptfg 
                INTO v_new_email, v_user_id;
                
                    UPDATE LEARNER 
                    SET email_address = v_new_email,
                           last_updated_by = 'SGAS',
                           last_updated_on = SYSDATE
                     WHERE learner_id = p_stud_ref;
                
                        CLOSE mail_cur_ptfg;
                END IF;    
                     
                ELSE 
            
                OPEN mail_cur_ptfg;
                FETCH mail_cur_ptfg 
                INTO v_new_email, v_user_id;       
                
                        IF v_new_email IS NOT NULL
                        
                        THEN
                        DBMS_OUTPUT.put_line ('- in steps_mail_change UPDATE BOTH ');
                        DBMS_OUTPUT.put_line ('- what is v_user_id ' || v_user_id);
                        DBMS_OUTPUT.put_line ('- what is v_new_email ' || v_new_email);
                            UPDATE stud
                            SET email_addr = v_new_email,
                                last_updated_by = USER,
                                last_updated_on = SYSDATE
                            WHERE portal_user_id = v_user_id;
                            
                            UPDATE ILA500.learner
                            SET email_address = v_new_email,
                                last_updated_by = USER,
                                last_updated_on = SYSDATE
                            WHERE web_user_id = v_user_id;
                            
                            CLOSE mail_cur_ptfg;
                         
                        END IF;

         
         
         
         END IF;
            
        ELSE
        
            DBMS_OUTPUT.put_line ('- in steps_mail_change WHERE NO USER_ID exists ');
                  BEGIN
                    SELECT stud_ref_no 
                    INTO v_stud_ref_no
                    FROM SGAS.STUD
                    WHERE stud_ref_no = p_stud_ref;
                 EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN   
                    SELECT learner_id 
                        INTO v_learner_id
                        FROM ILA500.LEARNER
                        WHERE learner_id = p_stud_ref;
                 END;  
                 
            DBMS_OUTPUT.put_line ('- WHAT IS  v_stud_ref_no ----- ' || v_stud_ref_no);  
            DBMS_OUTPUT.put_line ('- WHAT IS  v_learner_id ----- ' || v_learner_id);  
            
            IF v_stud_ref_no IS NOT NULL
                    THEN
            
                    DBMS_OUTPUT.put_line ('- in steps_mail_change WHERE NO USER_ID exists v_stud_ref_no IS NOT NULL ');
                        OPEN mail_cur;
                        FETCH mail_cur 
                        INTO v_new_email, v_user_id;   
                    DBMS_OUTPUT.put_line ('- in steps_mail_change WHERE NO USER_ID exists v_new_email IS --------> ' || v_new_email);
                        
                      IF v_new_email IS NOT NULL
                    
                        THEN
                        DBMS_OUTPUT.put_line ('- in UPDATE STUD exists v_new_email IS --------> ' || v_new_email); 
                        DBMS_OUTPUT.put_line ('- WHAT IS  v_stud_ref_no ----- ' || v_stud_ref_no); 
                         
                            UPDATE stud
                               SET email_addr = v_new_email,
                                   last_updated_by = 'SGAS',
                                   last_updated_on = SYSDATE
                             WHERE stud_ref_no = v_stud_ref_no;
                             
                             COMMIT;
                             DBMS_OUTPUT.put_line ('- AFTER COMMIT');  
                             CLOSE mail_cur;  
                
            
                    END IF;
            
                
            ELSE
                  
                  DBMS_OUTPUT.put_line ('- in steps_mail_change WHERE NO USER_ID exists v_learner_id IS NOT NULL ');
                    OPEN mail_cur_ptfg;
                    FETCH mail_cur_ptfg 
                    INTO v_new_email, v_user_id;
                    
                   DBMS_OUTPUT.put_line ('- in steps_mail_change WHERE NO USER_ID exists v_new_email IS --------> ' || v_new_email);  
                     IF v_new_email IS NOT NULL 
                     THEN  
                        UPDATE LEARNER 
                        SET email_address = v_new_email,
                               last_updated_by = 'SGAS',
                               last_updated_on = SYSDATE
                         WHERE learner_id = v_learner_id;
                         
                         COMMIT;
                    
                         CLOSE mail_cur_ptfg;
                         
                    END IF;     
                         
                            
                END IF;            
              
                
            
              
        
        END IF; 
               
        

      /* Delete the interface data only where the stud ref no exists*/

        DELETE FROM email_change@web
        WHERE stud_ref_no = p_stud_ref;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
        ROLLBACK;

        INSERT INTO sgas.email_change_exc 
                    (stud_ref_no, change_date, new_email,
                     SQLCODE, SQLERRM)
             VALUES (p_stud_ref, p_change_date, v_new_email,
                     v_sql_err_1, v_sql_err_2);

        COMMIT;
    END steps_mail_change;



    PROCEDURE steps_phone_change (p_stud_ref IN NUMBER, p_change_date IN DATE, p_user_id VARCHAR2)
    IS
        CURSOR phone_cur
        IS
            SELECT tele_no, mobile_tel_no   
              FROM phone_change@web
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;
               
         CURSOR phone_cur_ptfg
        IS
            SELECT tele_no, mobile_tel_no, user_id   
              FROM phone_change@web
             WHERE user_id = p_user_id
               AND TRUNC (change_date) = p_change_date; 
                     
        v_pt_and_ft    BOOLEAN := NULL; 
        v_user_id     VARCHAR(25) := NULL; 
        v_new_phone    stud_home_addr.tele_no%TYPE := NULL;
        v_new_mobile   stud.mobile_tel_no%TYPE := NULL;
        v_sqlcode      phone_change_exc.SQLCODE%TYPE := SQLCODE;
        v_sqlerrm      phone_change_exc.SQLERRM%TYPE := SQLERRM;
        v_sql_err_1    VARCHAR2 (25) := NULL;
        v_sql_err_2    VARCHAR2 (100) := NULL;
        l_stud_ref_no  NUMBER;
        l_stud_type    VARCHAR2(10) := NULL;
        
            
    
    BEGIN        
            
        DBMS_OUTPUT.put_line ('- in steps_phone_change');
        v_pt_and_ft := part_time_and_full_time(p_user_id);
        l_stud_type := part_time_or_full_time(p_user_id);
        
        dbms_output.put_line('what is v_pt_and_ft ' || sys.diutil.bool_to_int(v_pt_and_ft));
        DBMS_OUTPUT.put_line ('- what is l_stud_type ' || l_stud_type);
        
        IF v_pt_and_ft = FALSE
        THEN
            IF l_stud_type = 'STEPS_ONLY'
            THEN
            OPEN phone_cur;

            FETCH phone_cur
            INTO v_new_phone, v_new_mobile;

            IF v_new_phone IS NOT NULL
            THEN
                UPDATE stud_home_addr
                   SET tele_no = v_new_phone,
                       last_updated_by = USER,
                       last_updated_on = SYSDATE
                 WHERE stud_ref_no = p_stud_ref;
            END IF;

            IF v_new_mobile IS NOT NULL
            THEN
                UPDATE stud
                   SET mobile_tel_no = v_new_mobile,
                       last_updated_by = USER,
                       last_updated_on = SYSDATE
                 WHERE stud_ref_no = p_stud_ref;
            END IF;

            CLOSE phone_cur;
            
            
            
            
            ELSIF l_stud_type = 'PTFG_ONLY'

            
                THEN
                OPEN phone_cur_ptfg;

                FETCH phone_cur_ptfg
                INTO v_new_phone, v_new_mobile, v_user_id;
                            

                IF v_new_phone IS NOT NULL
                THEN
                    UPDATE ILA500.learner
                       SET telephone_no = v_new_phone,
                           last_updated_by = 'SGAS',
                           last_updated_on = SYSDATE
                     WHERE web_user_id = v_user_id;
                     
                     
                END IF;

                IF v_new_mobile IS NOT NULL
                THEN
                    UPDATE ILA500.learner
                       SET mobile_tel_no = v_new_mobile,
                           last_updated_by = USER,
                           last_updated_on = SYSDATE
                     WHERE web_user_id = v_user_id;
                END IF;

                CLOSE phone_cur_ptfg;

                END IF;
            
               ELSE  
            --PTFG CHANGE OF DETAILS
                    OPEN  phone_cur_ptfg;
                    FETCH phone_cur_ptfg
                    INTO v_new_phone, v_new_mobile, v_user_id;
                    
                    SELECT stud_ref_no
                    INTO l_stud_ref_no
                    FROM SGAS.stud s
                    WHERE S.PORTAL_USER_ID = v_user_id;
                    
                    IF v_new_phone IS NOT NULL
                    THEN
                        UPDATE SGAS.stud_home_addr
                           SET tele_no = v_new_phone,
                               last_updated_by = USER,
                               last_updated_on = SYSDATE
                         WHERE stud_ref_no = l_stud_ref_no;
                    END IF;

                    IF v_new_mobile IS NOT NULL
                    THEN
                        UPDATE SGAS.stud
                           SET mobile_tel_no = v_new_mobile,
                               last_updated_by = USER,
                               last_updated_on = SYSDATE
                         WHERE stud_ref_no = l_stud_ref_no;
                    END IF;
                    
                     IF v_new_phone IS NOT NULL
                    THEN
                        UPDATE ILA500.learner
                           SET telephone_no = v_new_phone,
                               mobile_tel_no = v_new_mobile,
                               last_updated_by = USER,
                               last_updated_on = SYSDATE
                         WHERE web_user_id = v_user_id;
                    END IF;
                    
                    CLOSE phone_cur_ptfg;

            END IF;

      /* Delete the interface data only where the stud ref no exists*/

        DELETE FROM phone_change@web
              WHERE stud_ref_no = p_stud_ref;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
        ROLLBACK;

        IF v_new_phone IS NOT NULL
        THEN
            INSERT INTO sgas.phone_change_exc 
                        (stud_ref_no, change_date, new_phone,
                         SQLCODE, SQLERRM)
                 VALUES (p_stud_ref, p_change_date, v_new_phone,
                         v_sql_err_1, v_sql_err_2);
        END IF;

        IF v_new_mobile IS NOT NULL
        THEN
            INSERT INTO sgas.phone_change_exc 
                        (stud_ref_no, change_date, new_phone,
                         SQLCODE, SQLERRM)
                 VALUES (p_stud_ref, p_change_date, v_new_mobile,
                         v_sql_err_1, v_sql_err_2);
        END IF;

        COMMIT;
    END steps_phone_change;



    PROCEDURE steps_home_change (p_stud_ref IN NUMBER, p_change_date IN DATE, p_user_id VARCHAR2)
    IS

        CURSOR home_cur
        IS
            SELECT UPPER (house_no_name), UPPER (addr_l1), UPPER (addr_l2), UPPER (addr_l3),
                   UPPER (addr_l4), UPPER (post_code)
              FROM home_addr_change@web
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;
               
        CURSOR home_cur_ptfg
        IS
            SELECT UPPER (house_no_name), UPPER (addr_l1), UPPER (addr_l2), UPPER (addr_l3),
                   UPPER (addr_l4), UPPER (post_code), user_id
              FROM home_addr_change@web
             WHERE user_id = p_user_id
               AND TRUNC (change_date) = p_change_date;

            v_house_no_name           sgas.stud_home_addr.house_no_name%TYPE := NULL;
            v_addr_l1                 sgas.stud_home_addr.addr_l1%TYPE := NULL;
            v_addr_l2                 sgas.stud_home_addr.addr_l2%TYPE := NULL;
            v_addr_l3                 sgas.stud_home_addr.addr_l3%TYPE := NULL;
            v_addr_l4                 sgas.stud_home_addr.addr_l4%TYPE := NULL;
            
            v_house_no_name_updated   sgas.stud_home_addr.house_no_name%TYPE := NULL;
            v_addr_l1_updated         sgas.stud_home_addr.addr_l1%TYPE := NULL;
            v_addr_l2_updated         sgas.stud_home_addr.addr_l2%TYPE := NULL;
            v_addr_l3_updated         sgas.stud_home_addr.addr_l3%TYPE := NULL;
            v_addr_l4_updated         sgas.stud_home_addr.addr_l4%TYPE := NULL;
            v_post_code               sgas.stud_home_addr.post_code%TYPE := NULL;
            v_tele_no                 sgas.stud_home_addr.tele_no%TYPE := NULL;
            v_sqlcode                 sgas.home_addr_change_exc.SQLCODE%TYPE := SQLCODE;
            v_sqlerrm                 sgas.home_addr_change_exc.SQLERRM%TYPE := SQLERRM;
            v_addr1_substring         VARCHAR2 (100) := NULL;
            v_sql_err_1               VARCHAR2 (25) := NULL;
            v_sql_err_2               VARCHAR2 (100) := NULL;
            v_user_id                 VARCHAR(25) := NULL; 
            v_pt_and_ft               BOOLEAN := NULL; 
            l_stud_ref_no             NUMBER;
            l_learner_id              VARCHAR2(10) := NULL;
            l_stud_type               VARCHAR2(10) := NULL;
            v_max_start_date          DATE;  

    BEGIN
        DBMS_OUTPUT.put_line ('- in steps_home_change');
        DBMS_OUTPUT.put_line ('What is p_user_id ************* '|| p_user_id);
        
        v_pt_and_ft := part_time_and_full_time(p_user_id);
        l_stud_type := part_time_or_full_time(p_user_id);
        DBMS_OUTPUT.put_line ('What is v_pt_and_ft ************* '|| sys.diutil.bool_to_int(v_pt_and_ft));
        DBMS_OUTPUT.put_line ('What is l_stud_type ************* '|| l_stud_type);
        
        IF v_pt_and_ft = FALSE
             THEN
                 IF l_stud_type = 'STEPS_ONLY'
                  THEN
                        OPEN home_cur;
                        FETCH home_cur
                            INTO v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3, v_addr_l4, v_post_code;

                        pk_change_details.addr_fix (v_house_no_name,
                                                    v_addr_l1,
                                                    v_addr_l2,
                                                    v_addr_l3,
                                                    v_addr_l4,
                                                    v_house_no_name_updated,
                                                    v_addr_l1_updated,
                                                    v_addr_l2_updated,
                                                    v_addr_l3_updated,
                                                    v_addr_l4_updated);
                        
                        -- Copy home phone number from ols location as it is possible to change this before the address
                        --  would lose this information
                        
                        SELECT tele_no
                          INTO v_tele_no
                          FROM sgas.stud_home_addr
                         WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;

                        -- Update end date
                        UPDATE sgas.stud_home_addr
                           SET end_date = TRUNC (p_change_date) - 1
                         WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;
                         
                       
                        --UTL_FILE.put_line (logfile_out, 'update stud_home_addr done');
                        DBMS_OUTPUT.put_line ('update stud_home_addr done');

                        INSERT INTO sgas.stud_home_addr 
                                    (stud_ref_no, start_date, house_no_name, addr_l1,
                                     addr_l2, addr_l3, addr_l4, post_code, tele_no)
                             VALUES (p_stud_ref, SYSDATE, v_house_no_name_updated, v_addr_l1_updated,
                                     v_addr_l2_updated, v_addr_l3_updated, v_addr_l4_updated, v_post_code, v_tele_no
                                    );

                        CLOSE home_cur;
                
                        ELSIF l_stud_type = 'PTFG_ONLY'
                            THEN                
                                   OPEN home_cur_ptfg;
                                        FETCH home_cur_ptfg
                                     INTO v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3, v_addr_l4, v_post_code, v_user_id;
                                     
                                                 
                                    SELECT learner_id
                                    INTO l_learner_id
                                    FROM ILA500.LEARNER
                                    WHERE web_user_id = v_user_id;
                                    
                                    pk_change_details.addr_fix (v_house_no_name,
                                                                    v_addr_l1,
                                                                    v_addr_l2,
                                                                    v_addr_l3,
                                                                    v_addr_l4,
                                                                    v_house_no_name_updated,
                                                                    v_addr_l1_updated,
                                                                    v_addr_l2_updated,
                                                                    v_addr_l3_updated,
                                                                    v_addr_l4_updated);
                                                                    
                                                                    --DO THE PART TIME UPDATE
                                        
                                        UPDATE ILA500.LEARNER
                                        SET housename_no = v_house_no_name_updated,
                                            ADDRESS_LINE1 = v_addr_l1_updated,
                                            ADDRESS_LINE2 = v_addr_l2_updated,
                                            ADDRESS_LINE3 = v_addr_l3_updated,
                                            ADDRESS_LINE4 = v_addr_l4_updated,
                                            POSTCODE      = v_post_code
                                            WHERE learner_id = l_learner_id;
                                            
                                            CLOSE home_cur_ptfg;
                 END IF;
     
                
                
            ELSE
        
                    DBMS_OUTPUT.put_line ('IN THE ELSE AS BOTH PT AND FT');
                
        
                OPEN home_cur_ptfg;
                FETCH home_cur_ptfg
                INTO v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3, v_addr_l4, v_post_code, v_user_id;
                
                 OPEN home_cur;
                 FETCH home_cur
                 INTO v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3, v_addr_l4, v_post_code;
                
                 DBMS_OUTPUT.put_line ('AFTER THE FETCHES');
               
                --DO THE FULL TIME 
                    SELECT stud_ref_no
                    INTO l_stud_ref_no
                    FROM SGAS.stud s
                    WHERE S.PORTAL_USER_ID = v_user_id;
                    
                    SELECT learner_id
                    INTO l_learner_id
                    FROM ILA500.LEARNER
                    WHERE web_user_id = v_user_id;

                    
                
                pk_change_details.addr_fix (v_house_no_name,
                                                    v_addr_l1,
                                                    v_addr_l2,
                                                    v_addr_l3,
                                                    v_addr_l4,
                                                    v_house_no_name_updated,
                                                    v_addr_l1_updated,
                                                    v_addr_l2_updated,
                                                    v_addr_l3_updated,
                                                    v_addr_l4_updated);
               DBMS_OUTPUT.put_line ('AFTER THE ADDR FIX');
                        
                        -- Copy home phone number from ols location as it is possible to change this before the address
                        --  would lose this information

                        SELECT tele_no
                          INTO v_tele_no
                          FROM sgas.stud_home_addr
                         WHERE stud_ref_no = l_stud_ref_no AND end_date IS NULL;
                         

                        -- Update end date
                        UPDATE sgas.stud_home_addr
                           SET end_date = TRUNC (p_change_date) - 1
                         WHERE stud_ref_no = l_stud_ref_no AND end_date IS NULL;
                         COMMIT;
                         

                       
                        --UTL_FILE.put_line (logfile_out, 'update stud_home_addr done');
                        DBMS_OUTPUT.put_line ('update stud_home_addr done');

                        INSERT INTO sgas.stud_home_addr 
                                    (stud_ref_no, start_date, house_no_name, addr_l1,
                                     addr_l2, addr_l3, addr_l4, post_code, tele_no)
                             VALUES (l_stud_ref_no, SYSDATE, v_house_no_name_updated, v_addr_l1_updated,
                                     v_addr_l2_updated, v_addr_l3_updated, v_addr_l4_updated, v_post_code, v_tele_no
                                    );
                          COMMIT;                 
                    
                        --DO THE PART TIME UPDATE

                        UPDATE ILA500.LEARNER
                        SET housename_no = v_house_no_name_updated,
                            ADDRESS_LINE1 = v_addr_l1_updated,
                            ADDRESS_LINE2 = v_addr_l2_updated,
                            ADDRESS_LINE3 = v_addr_l3_updated,
                            ADDRESS_LINE4 = v_addr_l4_updated,
                            POSTCODE      = v_post_code
                            WHERE learner_id = l_learner_id;
                            DBMS_OUTPUT.put_line ('have we got to the UPDATE COMMIT?');
                            COMMIT;
                            DBMS_OUTPUT.put_line ('have we got past the UPDATE COMMIT?');
                            
                   select max(start_date)
                   INTO v_max_start_date
                   FROM sgas.stud_home_addr
                   WHERE stud_ref_no = l_stud_ref_no;
                   DBMS_OUTPUT.put_line ('v_max_start_date '|| v_max_start_date);
                   
                   UPDATE sgas.stud_home_addr
                   SET end_date = NULL 
                   WHERE start_date = v_max_start_date
                   AND stud_ref_no = l_stud_ref_no;
                            
                            CLOSE home_cur_ptfg;
                            CLOSE home_cur;
                            

                END IF;                

        /* Delete the interface data only where the stud ref no exists*/

        DELETE FROM home_addr_change@web
              WHERE stud_ref_no = p_stud_ref;
        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
            ROLLBACK;

            INSERT INTO sgas.home_addr_change_exc 
                        (stud_ref_no, change_date, house_no_name, addr_l1, addr_l2,
                         addr_l3, addr_l4, post_code, SQLCODE, SQLERRM)
                 VALUES (p_stud_ref, p_change_date, v_house_no_name_updated,v_addr_l1_updated,
                         v_addr_l2_updated, v_addr_l3_updated, v_addr_l4_updated, v_post_code,
                         v_sql_err_1, v_sql_err_2);

            COMMIT;
    END steps_home_change;


    PROCEDURE steps_loan_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
    IS
        /*******************************************************************************

        FIRST CONTACT DETAILS

        ******************************************************************************/

        CURSOR loan_cur1
        IS
            SELECT UPPER (name_1), UPPER (addr_l1_1), 
                   UPPER (addr_l2_1), UPPER (addr_l3_1), 
                   UPPER (post_code_1), tel_no_1, rel_code_1
              FROM loan_contacts_change@web
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;

            v_name_1            sgas.stud_cont_details.cont_name%TYPE := NULL;
            v_addr_l1_1         sgas.stud_cont_details.cont_addr1%TYPE := NULL;
            v_addr_l2_1         sgas.stud_cont_details.cont_addr2%TYPE := NULL;
            v_addr_l3_1         sgas.stud_cont_details.cont_addr3%TYPE := NULL;
            v_post_code_1       sgas.stud_cont_details.cont_postcode%TYPE := NULL;
            v_tel_no_1          sgas.stud_cont_details.cont_tel_no%TYPE := NULL;
            v_rel_code_1        sgas.stud_cont_details.cont_rel_code%TYPE := NULL;
            v_addr1_substring   VARCHAR2 (100) := NULL;
            v_sqlcode           sgas.loan_contacts_change_exc.SQLCODE%TYPE := SQLCODE;
            v_sqlerrm           sgas.loan_contacts_change_exc.SQLERRM%TYPE := SQLERRM;
            v_sql_err_1         VARCHAR2 (25) := NULL;
            v_sql_err_2         VARCHAR2 (100) := NULL;

        /*******************************************************************************

        SECOND CONTACT DETAILS

        ******************************************************************************/

        CURSOR loan_cur2
        IS
            SELECT UPPER (name_2),UPPER (addr_l1_2), 
                   UPPER (addr_l2_2), UPPER (addr_l3_2), 
                   UPPER (post_code_2), tel_no_2, rel_code_2
              FROM loan_contacts_change@web
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;

            v_name_2            sgas.stud_cont_details.cont_name%TYPE := NULL;
            v_addr_l1_2         sgas.stud_cont_details.cont_addr1%TYPE := NULL;
            v_addr_l2_2         sgas.stud_cont_details.cont_addr2%TYPE := NULL;
            v_addr_l3_2         sgas.stud_cont_details.cont_addr3%TYPE := NULL;
            v_post_code_2       sgas.stud_cont_details.cont_postcode%TYPE := NULL;
            v_tel_no_2          sgas.stud_cont_details.cont_tel_no%TYPE := NULL;
            v_rel_code_2        sgas.stud_cont_details.cont_rel_code%TYPE := NULL;
            v_addr2_substring   VARCHAR2 (100) := NULL;
            v_point             VARCHAR2 (1000);
            v_session_code      NUMBER;
    BEGIN
        DBMS_OUTPUT.put_line ('- in steps_loan_change');
        /*******************************************************************************

        FIRST CONTACT DETAILS

        ******************************************************************************/
    
        OPEN loan_cur1;
        FETCH loan_cur1
            INTO v_name_1, v_addr_l1_1, v_addr_l2_1, 
                 v_addr_l3_1, v_post_code_1, v_tel_no_1, 
                 v_rel_code_1;

        IF v_name_1 IS NOT NULL
        THEN
            v_point := 'update 1';

             IF f_cont1_exists (p_stud_ref)   -- If contact 1 exists update else insert
            THEN
                UPDATE sgas.stud_cont_details
                   SET cont_name = v_name_1,
                       cont_addr1 = v_addr_l1_1,
                       cont_addr2 = v_addr_l2_1,
                       cont_addr3 = v_addr_l3_1,
                       cont_postcode = v_post_code_1,
                       cont_tel_no = v_tel_no_1,
                       cont_rel_code = v_rel_code_1,
                       last_updated_by = USER,
                       last_updated_on = SYSDATE
                 WHERE stud_ref_no = p_stud_ref AND contact_ind = 1;
            ELSE
                v_point := 'insert 1';

                INSERT INTO sgas.stud_cont_details 
                            (stud_ref_no, contact_ind, cont_name, cont_addr1,
                             cont_addr2, cont_addr3, cont_postcode, cont_tel_no,
                             cont_rel_code, last_updated_by, last_updated_on)
                     VALUES (p_stud_ref, 1,v_name_1, v_addr_l1_1,
                             v_addr_l2_1, v_addr_l3_1, v_post_code_1, v_tel_no_1,
                             v_rel_code_1, USER, SYSDATE);
            END IF;
        END IF;
        CLOSE loan_cur1;

      /*******************************************************************************

       SECOND CONTACT DETAILS

       ******************************************************************************/

        OPEN loan_cur2;
        FETCH loan_cur2
            INTO v_name_2, v_addr_l1_2, v_addr_l2_2,
                 v_addr_l3_2, v_post_code_2, v_tel_no_2, v_rel_code_2;
                 
        IF v_name_2 IS NOT NULL
        THEN
 
            IF f_cont2_exists (p_stud_ref)
            THEN
                v_point := 'update 2';

                UPDATE sgas.stud_cont_details
                   SET cont_name = v_name_2,
                       cont_addr1 = v_addr_l1_2, 
                       cont_addr2 = v_addr_l2_2,
                       cont_addr3 = v_addr_l3_2,
                       cont_postcode = v_post_code_2,
                       cont_tel_no = v_tel_no_2,
                       cont_rel_code = v_rel_code_2,
                       last_updated_by = USER,
                       last_updated_on = SYSDATE
                WHERE stud_ref_no = p_stud_ref AND contact_ind = 2;
            ELSE
                v_point := 'insert 2';

                INSERT INTO sgas.stud_cont_details 
                            (stud_ref_no, contact_ind, cont_name, cont_addr1, cont_addr2,
                             cont_addr3, cont_postcode, cont_tel_no, cont_rel_code,
                             last_updated_by, last_updated_on)
                     VALUES (p_stud_ref, 2, v_name_2, v_addr_l1_2, v_addr_l2_2, v_addr_l3_2, 
                             v_post_code_2, v_tel_no_2, v_rel_code_2,
                             USER, SYSDATE);
            END IF;
        END IF;
        CLOSE loan_cur2;

        /* CR 239 and defect 83 (StEPS_Defects) update STUD_CRSE_YEAR.slc1_sent and
            STUD_CRSE_YEAR.slc2_sent to equal 'N' if v_point is not null*/

        IF v_point IS NOT NULL
        THEN
            SELECT MAX (session_code)
              INTO v_session_code
              FROM stud_crse_year
             WHERE stud_ref_no = p_stud_ref;

            UPDATE stud_crse_year
               SET SLC1_SENT = 'N', SLC2_SENT = 'N'
             WHERE latest_crse_ind = 'Y'
               AND session_code = v_session_code
               AND stud_ref_no = p_stud_ref;
        END IF;

        /* END CR 239 and defect 83 (StEPS_Defects) */

        /* Delete the interface data only where the stud ref no exists*/

        DELETE FROM loan_contacts_change@web
              WHERE stud_ref_no = p_stud_ref;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
            ROLLBACK;
            INSERT INTO sgas.loan_contacts_change_exc 
                        (stud_ref_no, change_date, name_1, addr_l1_1, addr_l2_1,
                         addr_l3_1, post_code_1, tel_no_1, rel_code_1, name_2,
                         addr_l1_2, addr_l2_2, addr_l3_2, post_code_2, tel_no_2,
                         rel_code_2, SQLCODE, SQLERRM)
                 VALUES (p_stud_ref, p_change_date, v_name_1, v_addr_l1_1, v_addr_l2_1,
                         v_addr_l3_1, v_post_code_1, v_tel_no_1, v_rel_code_1, v_name_2,
                         v_addr_l1_2, v_addr_l2_2, v_addr_l3_2, v_post_code_2, v_tel_no_2,
                         v_rel_code_2, v_sql_err_1, v_sql_err_2);

            COMMIT;
    END steps_loan_change;

    PROCEDURE steps_personal_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
    IS
        CURSOR personal_cur
        IS
            SELECT dob
              FROM stud_change@web            
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;
            
            v_dob                  stud.dob%TYPE := NULL;
            v_sql_err_1            VARCHAR2 (25) := NULL;
            v_sql_err_2            VARCHAR2 (100) := NULL;
  
    BEGIN
        DBMS_OUTPUT.put_line ('- in steps_personal_change');
        OPEN personal_cur;
        FETCH personal_cur
         INTO v_dob; 
        
        UPDATE stud
           SET     dob = v_dob,
                last_updated_by = USER,
                last_updated_on = SYSDATE
         WHERE stud.stud_ref_no = p_stud_ref;
        
        CLOSE personal_cur;

        /* Delete the interface data only where the stud ref no exists*/
    
        DELETE FROM stud_change@web
              WHERE stud_ref_no = p_stud_ref;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
            ROLLBACK;
            INSERT INTO sgas.stud_change_exc 
                        (stud_ref_no, change_date,  dob, SQLCODE, SQLERRM)
                 VALUES (p_stud_ref, p_change_date, v_dob, v_sql_err_1,v_sql_err_2);

            COMMIT;
    END steps_personal_change;

    PROCEDURE steps_term_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
    IS
        CURSOR term_cur
        IS
            SELECT UPPER (house_no_name), UPPER (addr_l1), UPPER (addr_l2), UPPER (addr_l3),
                   UPPER (addr_l4), UPPER (post_code) 
              FROM term_addr_change@web
             WHERE stud_ref_no = p_stud_ref
               AND TRUNC (change_date) = p_change_date;

            v_house_no_name           sgas.stud_term_addr.house_no_name%TYPE := NULL;
            v_addr_l1                 sgas.stud_term_addr.addr_l1%TYPE := NULL;
            v_addr_l2                 sgas.stud_term_addr.addr_l2%TYPE := NULL;
            v_addr_l3                 sgas.stud_term_addr.addr_l3%TYPE := NULL;
            v_addr_l4                 sgas.stud_term_addr.addr_l4%TYPE := NULL;
            v_house_no_name_updated   sgas.stud_term_addr.house_no_name%TYPE := NULL;
            v_addr_l1_updated         sgas.stud_term_addr.addr_l1%TYPE := NULL;
            v_addr_l2_updated         sgas.stud_term_addr.addr_l2%TYPE := NULL;
            v_addr_l3_updated         sgas.stud_term_addr.addr_l3%TYPE := NULL;
            v_addr_l4_updated         sgas.stud_term_addr.addr_l4%TYPE := NULL;
            v_post_code               sgas.stud_term_addr.post_code%TYPE := NULL;
            v_sqlcode                 sgas.term_addr_change_exc.SQLCODE%TYPE := SQLCODE;
            v_sqlerrm                 sgas.term_addr_change_exc.SQLERRM%TYPE := SQLERRM;
            v_stud_crse_year_id       sgas.stud_crse_year.stud_crse_year_id%TYPE;
            v_sess_code               sgas.config_data.cval%TYPE;
            v_addr1_substring         VARCHAR2 (100) := NULL;
            v_sql_err_1               VARCHAR2 (25) := NULL;
            v_sql_err_2               VARCHAR2 (100) := NULL;
    BEGIN
        --UTL_FILE.put_line (logfile_out, 'in term change =' || p_stud_ref || '=' || p_change_date);
        DBMS_OUTPUT.put_line ('in term change =' || p_stud_ref || '=' || p_change_date);
        OPEN term_cur;

        FETCH term_cur
            INTO v_house_no_name, v_addr_l1, v_addr_l2,v_addr_l3, v_addr_l4, v_post_code;    

        DBMS_OUTPUT.put_line ('fetched address = ' || v_house_no_name||' '||v_addr_l1 || ' ' || v_addr_l2|| ' '||v_addr_l3||' '||v_addr_l4||' ' ||v_post_code);
        pk_change_details.addr_fix (v_house_no_name,
                                    v_addr_l1,
                                    v_addr_l2,
                                    v_addr_l3,
                                    v_addr_l4,
                                    v_house_no_name_updated,
                                    v_addr_l1_updated,
                                    v_addr_l2_updated,
                                    v_addr_l3_updated,
                                    v_addr_l4_updated);

        DBMS_OUTPUT.put_line ('updated address = ' || v_house_no_name_updated||', '||v_addr_l1_updated || ', ' || v_addr_l2_updated || ', '||v_addr_l3_updated||', '||v_addr_l4_updated);
        --UTL_FILE.put_line (logfile_out, 'postfetch =' || SQLCODE);
        DBMS_OUTPUT.put_line ('postfetch =' || SQLCODE);

        UPDATE sgas.stud_term_addr
           SET end_date = TRUNC (p_change_date) - 1
         WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;

        --UTL_FILE.put_line (logfile_out, 'postupdate =' || SQLCODE);
        DBMS_OUTPUT.put_line ('postupdate =' || SQLCODE);

        INSERT INTO sgas.stud_term_addr 
                    (stud_ref_no, start_date, house_no_name, addr_l1, addr_l2,
                     addr_l3, addr_l4, post_code
                    )
             VALUES (p_stud_ref, SYSDATE, v_house_no_name_updated, v_addr_l1_updated,
                    v_addr_l2_updated, v_addr_l3_updated, v_addr_l4_updated,
                    v_post_code 
                    );

        --UTL_FILE.put_line (logfile_out, 'postinsert =' || SQLCODE);
        DBMS_OUTPUT.put_line ('postinsert =' || SQLCODE);

        CLOSE term_cur;

        /* Delete the interface data only where the stud ref no exists*/
    
        DELETE FROM term_addr_change@web
             WHERE stud_ref_no = p_stud_ref;

        SELECT cval
          INTO v_sess_code
          FROM config_data
         WHERE UPPER (item_name) = 'CURRENT_SESSION';

        SELECT stcy.stud_crse_year_id
          INTO v_stud_crse_year_id
          FROM stud_crse_year stcy
         WHERE stcy.stud_ref_no = p_stud_ref
           AND stcy.session_code = v_sess_code
           AND stcy.latest_crse_ind = 'Y';

        INSERT INTO sgas.batch_recalc 
                    (stud_crse_year_id, recall_date, stud_ref_no, pass_fail, error_message)
             VALUES (v_stud_crse_year_id, SYSDATE, p_stud_ref, NULL, NULL);

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            v_sql_err_1 := SQLCODE;
            v_sql_err_2 := SQLERRM;
            ROLLBACK;

            INSERT INTO sgas.term_addr_change_exc 
                        (stud_ref_no, change_date, house_no_name, addr_l1, addr_l2,
                         addr_l3, addr_l4, post_code, 
                         SQLCODE, SQLERRM)
                 VALUES (p_stud_ref, p_change_date, v_house_no_name_updated, v_addr_l1_updated,
                         v_addr_l2_updated, v_addr_l3_updated, v_addr_l4_updated, v_post_code,
                         v_sql_err_1, v_sql_err_2);

            COMMIT;
    END steps_term_change;

/* Formatted on 10/07/2018 12:24:46 (QP5 v5.256.13226.35538) */
PROCEDURE steps_course_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
IS
   V_ERRM   VARCHAR2 (1024);
BEGIN
   INSERT INTO SGAS.COURSE_CHANGE (STUD_REF_NO,
                                   CHANGE_DATE,
                                   INST_CODE,
                                   CRSE_ID,
                                   CRSE_NAME,
                                   SCHEME_TYPE,
                                   CRSE_YEAR_NO,
                                   OTHER_CRSE,
                                   OLD_INST_CODE,
                                   OLD_CRSE_ID,
                                   OLD_CRSE_NAME,
                                   OLD_SCHEME_TYPE,
                                   OLD_CRSE_YEAR_NO,
                                   WITHDRAW,
                                   WITHDRAW_DATE,
                                   WITHDRAW_REASON,
                                   SESSION_CODE)
      SELECT STUD_REF_NO,
             CHANGE_DATE,
             INST_CODE,
             CRSE_ID,
             CRSE_NAME,
             SCHEME_TYPE,
             CRSE_YEAR_NO,
             OTHER_CRSE,
             OLD_INST_CODE,
             OLD_CRSE_ID,
             OLD_CRSE_NAME,
             OLD_SCHEME_TYPE,
             OLD_CRSE_YEAR_NO,
             WITHDRAW,
             WITHDRAW_DATE,
             WITHDRAW_REASON,
             SESSION_CODE
        FROM COURSE_CHANGE@WEB CCW
       WHERE CCW.STUD_REF_NO = p_stud_ref;
       
       UPDATE COURSE_CHANGE@WEB CCW
       SET CCW.DATE_TRANSFER_TO_STEPS = SYSDATE
       WHERE CCW.STUD_REF_NO = p_stud_ref;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      BEGIN
         ROLLBACK;
         V_ERRM := SUBSTR ('STUD_REF_NO = '||to_char(p_stud_ref)||' ' ||SQLERRM, 1, 1024);

         INSERT INTO SGAS.COURSE_CHANGE_ERROR (ERROR_TEXT)
              VALUES (V_ERRM);

         COMMIT;
      END;
END steps_course_change;
    

    FUNCTION f_cont1_exists (p_stud_ref IN NUMBER)
        RETURN BOOLEAN
    IS
        CURSOR cont1_cur
        IS
            SELECT 1
            FROM sgas.stud_cont_details
            WHERE stud_ref_no = p_stud_ref AND contact_ind = 1;

            v_result   NUMBER := 0;
    BEGIN
        OPEN cont1_cur;

        FETCH cont1_cur INTO v_result;

        IF v_result = 1
        THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;

        CLOSE cont1_cur;
    EXCEPTION
        WHEN OTHERS
        THEN
            --UTL_FILE.put_line (logfile_out, SQLCODE || SQLERRM);
            DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
            RETURN FALSE;
    END f_cont1_exists;



    FUNCTION f_cont2_exists (p_stud_ref IN NUMBER)
        RETURN BOOLEAN
    IS
        CURSOR cont2_cur
        IS
            SELECT 1
            FROM sgas.stud_cont_details
            WHERE stud_ref_no = p_stud_ref AND contact_ind = 2;

            v_result   NUMBER := 0;
    BEGIN
        OPEN cont2_cur;

        FETCH cont2_cur INTO v_result;

        IF v_result = 1
        THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;

        CLOSE cont2_cur;
    EXCEPTION
        WHEN OTHERS
        THEN
            --UTL_FILE.put_line (logfile_out, SQLCODE || SQLERRM);
            DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
            RETURN FALSE;
    END f_cont2_exists;  
    
    
    FUNCTION part_time_and_full_time(p_web_user_id IN VARCHAR2)
     RETURN BOOLEAN
    IS
    
    v_web_user_steps VARCHAR2(25) := NULL;
    v_web_user_ptfg  VARCHAR2(25) := NULL;
    
    
    

    
    BEGIN
    DBMS_OUTPUT.put_line('*********part_time_and_full_time*********');
            /* Formatted on 20/10/2021 19:50:10 (QP5 v5.256.13226.35538) */
            BEGIN
               SELECT web_user_id
                 INTO v_web_user_ptfg
                 FROM ILA500.learner
                WHERE web_user_id = p_web_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  --DBMS_OUTPUT.put_line ('No web_user_id found!');
                  SELECT portal_user_id
                    INTO v_web_user_steps
                    FROM SGAS.stud
                   WHERE portal_user_id = p_web_user_id;
            END;

            BEGIN
               SELECT portal_user_id
                 INTO v_web_user_steps
                 FROM SGAS.stud
                WHERE portal_user_id = p_web_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT web_user_id
                    INTO v_web_user_ptfg
                    FROM ILA500.learner
                   WHERE web_user_id = p_web_user_id;
            END;

        
        
                /* Formatted on 20/10/2021 17:46:55 (QP5 v5.256.13226.35538)
                BEGIN
                   SELECT portal_user_id
                     INTO v_web_user_steps
                     FROM SGAS.stud
                    WHERE web_user_id = p_web_user_id;
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      DBMS_OUTPUT.put_line ('No web_user_id found');
                END;
                 */

        
        IF (v_web_user_ptfg = v_web_user_steps)
        THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
            DBMS_OUTPUT.put_line('*********END part_time_and_full_time*********');
   EXCEPTION
        WHEN OTHERS
        THEN
            --UTL_FILE.put_line (logfile_out, SQLCODE || SQLERRM);
            DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
            RETURN FALSE;
   END part_time_and_full_time;    
   
   
   FUNCTION part_time_or_full_time(p_web_user_id IN VARCHAR2)
     RETURN VARCHAR2
    IS
    
    v_web_user_steps VARCHAR2(25) := NULL;
    v_web_user_ptfg  VARCHAR2(25) := NULL; 
    
    PTFG_ONLY VARCHAR2(10);
    STEPS_ONLY VARCHAR2(10);
    BOTH_PT_FT VARCHAR2 (10);
    message  VARCHAR2(15);
    
    

    
    BEGIN
    
    DBMS_OUTPUT.put_line('*********part_time_or_full_time*********');
            /* Formatted on 20/10/2021 19:50:10 (QP5 v5.256.13226.35538) */
            BEGIN
               SELECT web_user_id
                 INTO v_web_user_ptfg
                 FROM ILA500.learner
                WHERE web_user_id = p_web_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  --DBMS_OUTPUT.put_line ('No web_user_id found!');
                  SELECT portal_user_id
                    INTO v_web_user_steps
                    FROM SGAS.stud
                   WHERE web_user_id = p_web_user_id;
            END;
        DBMS_OUTPUT.put_line ('What is v_web_user_ptfg ************* '|| v_web_user_ptfg);
        
            BEGIN
               SELECT portal_user_id
                 INTO v_web_user_steps
                 FROM SGAS.stud
                WHERE web_user_id = p_web_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT web_user_id
                    INTO v_web_user_ptfg
                    FROM ILA500.learner
                   WHERE web_user_id = p_web_user_id;
            END;
           DBMS_OUTPUT.put_line ('What is v_web_user_steps ************* '|| v_web_user_steps);
            

        
        IF ((v_web_user_ptfg IS NOT NULL) AND (v_web_user_steps IS NULL))
        THEN

              PTFG_ONLY := 'PTFG_ONLY';
            RETURN PTFG_ONLY;
        ELSIF ((v_web_user_steps IS NOT NULL) AND (v_web_user_ptfg IS NULL))
        THEN

            STEPS_ONLY := 'STEPS_ONLY';
            RETURN STEPS_ONLY;
        ELSE

              BOTH_PT_FT := 'BOTH_PT_FT'; 
         RETURN BOTH_PT_FT;
        END IF;
        
        
   EXCEPTION
        WHEN OTHERS
        THEN
            --UTL_FILE.put_line (logfile_out, SQLCODE || SQLERRM);
            DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
            message := 'UNKNOWN';
            RETURN message;
   END part_time_or_full_time;    


    PROCEDURE addr_fix (p_house_no_name           IN            VARCHAR2,
                        p_addr_l1                 IN            VARCHAR2,
                        p_addr_l2                 IN            VARCHAR2,
                        p_addr_l3                 IN            VARCHAR2,
                        p_addr_l4                 IN            VARCHAR2,
                        v_house_no_name_updated   OUT NOCOPY    VARCHAR2,
                        v_addr_l1_updated         OUT NOCOPY    VARCHAR2,
                        v_addr_l2_updated         OUT NOCOPY    VARCHAR2,
                        v_addr_l3_updated         OUT NOCOPY    VARCHAR2,
                        v_addr_l4_updated         OUT NOCOPY    VARCHAR2)
    IS
    BEGIN
        v_house_no_name_updated := p_house_no_name;
        v_addr_l1_updated := p_addr_l1;
        v_addr_l2_updated := p_addr_l2;
        v_addr_l3_updated := p_addr_l3;
        v_addr_l4_updated := p_addr_l4;

        -- Correct duplicated house no/name

        SELECT REPLACE (v_addr_l1_updated, v_house_no_name_updated)
                  INTO  v_addr_l1_updated
                  FROM DUAL;

        SELECT LTRIM (v_addr_l1_updated) INTO v_addr_l1_updated FROM DUAL;

        SELECT RTRIM (v_addr_l1_updated) INTO v_addr_l1_updated FROM DUAL;

        -- Move populated lines up

        IF v_addr_l1_updated IS NULL OR LENGTH (v_addr_l1_updated) = 0
        THEN
            v_addr_l1_updated := v_addr_l2_updated;
            v_addr_l2_updated := v_addr_l3_updated;
            v_addr_l3_updated := v_addr_l4_updated;
            v_addr_l4_updated := NULL;
        END IF;

        IF v_addr_l2_updated IS NULL OR LENGTH (v_addr_l2_updated) = 0
        THEN
            v_addr_l2_updated := v_addr_l3_updated;
            v_addr_l3_updated := v_addr_l4_updated;
            v_addr_l4_updated := NULL;
        END IF;
      
        IF v_addr_l3_updated IS NULL OR LENGTH (v_addr_l3_updated) = 0
        THEN
            v_addr_l3_updated := v_addr_l4_updated;
            v_addr_l4_updated := NULL;
        END IF;
    END addr_fix;
    
    


END pk_change_details;


         
         
--New Batch type entry for 98 'Online Change of Course/Withdrawal
/
