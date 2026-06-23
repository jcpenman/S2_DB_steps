-- VU_SDS.sql
-- Description: dbView holding all learner contact detail and application status change data for ILA500 SDS interface
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      16.07.08    R Hunter (SAAS)         Initial Version.
-- 2.0      25.02.09    R Hunter (SAAS)         Added date_changed_mail_returned column to assist Angel SDS XML reporting
-- 3.0      07.04.09    R Hunter (SAAS)         Removed references to newly created data, 'I' inserted data, not needed for SDS
-- 4.0      20.05.09    A.Bowman (SAAS)         Added references to newly created date, 'I' inserted data where app status is not NEW
-- 4.1      28.05.09    A.Bowman (SAAS)         Code has been amended to correctly pick up newly inserted data only where the status is not NEW
-- 5.0      13.07/09    R.Hunter (SAAS)         Added hints to improve performance of query.
-- 6.0	    30.07/10	P.Hughes (SAAS)		Added Session_Year to be returned by query in respect of new 2010 changes.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Views/VU_SDS.sql $
-- $Author: $
-- $Date: 2010-10-21 10:46:57 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5798 $

DROP VIEW ILA500.VU_SDS;

/* Formatted on 2010/07/30 14:19 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW ila500.vu_sds (ila_ref_no,
                                            session_year,
                                            title,
                                            title_change_date,
                                            last_name,
                                            surname_change_date,
                                            first_name,
                                            forename_change_date,
                                            date_of_birth,
                                            dob_change_date,
                                            gender,
                                            gender_change_date,
                                            house_name_no,
                                            housename_no_change_date,
                                            address_line_1,
                                            addr1_change_date,
                                            address_line_2,
                                            addr2_change_date,
                                            address_line_3,
                                            addr3_change_date,
                                            address_line_4,
                                            addr4_change_date,
                                            postcode,
                                            postcode_change_date,
                                            phone_number,
                                            phone_change_date,
                                            email_address,
                                            email_change_date,
                                            changed_status,
                                            status_changed_date,
                                            date_of_withdrawal,
                                            learner_is_deceased,
                                            date_notified_deceased,
                                            date_learner_mail_returned,
                                            date_changed_mail_returned
                                           )
AS
   SELECT   /*+ full(l) parallel(l,35)*/
            l.learner_id AS ila_ref_no, lap.session_year,
            NVL (other_title, ti.description) AS title,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('TITLE_ID')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS title_change_date,
            surname AS last_name,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('SURNAME')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS surname_change_date,
            forename AS first_name,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('FORENAME')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS forename_change_date,
            dob AS date_of_birth,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('DOB')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS dob_change_date,
            gender AS gender,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('GENDER')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS gender_change_date,
            housename_no AS house_name_no,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('HOUSENAME_NO')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS housename_no_change_date,
            address_line1 AS address_line_1,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('ADDRESS_LINE1')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS addr1_change_date,
            address_line2 AS address_line_2,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('ADDRESS_LINE2')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS addr2_change_date,
            address_line3 AS address_line_3,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('ADDRESS_LINE3')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS addr3_change_date,
            address_line4 AS address_line_4,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('ADDRESS_LINE4')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS addr4_change_date,
            postcode AS postcode,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('POSTCODE')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS postcode_change_date,
            telephone_no AS phone_number,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('TELEPHONE_NO')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS phone_change_date,
            email_address AS email_address,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name IN ('EMAIL_ADDRESS')
                AND action = 'U'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS email_change_date,
            (SELECT st.status
               FROM application_status st,
                    (SELECT   *
                         FROM learner_application_aud
                     ORDER BY aud_date DESC) laa
              WHERE lap.learner_application_id = laa.primary_key
                AND UPPER (laa.column_name) = 'APPLICATION_STATUS_ID'
                AND (   (    action = 'I'                -- 4.1 ADDED BY ANGEL
                         AND st.application_status_id = laa.NEW
                         AND st.application_status_id IN (
                                SELECT application_status_id
                                  FROM application_status
                                 WHERE status = 'RETURNED'
                                    OR status = 'REJECTED')
                        )
                     OR (action = 'U' AND st.application_status_id = laa.NEW
                        )
                    )                                -- 4.1 END ADDED BY ANGEL
                AND ROWNUM < 2) AS changed_status,
            (SELECT laa.aud_date
               FROM (SELECT   *
                         FROM learner_application_aud
                     ORDER BY aud_date DESC) laa
              WHERE lap.learner_application_id = laa.primary_key
                AND UPPER (laa.column_name) = 'APPLICATION_STATUS_ID'
                AND action IN ('I', 'U')
                AND ROWNUM < 2) AS status_changed_date,
            date_withdrawn AS date_of_withdrawal,
            deceased_flag AS learner_is_deceased,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name = 'DECEASED_FLAG'
                AND NEW = 'Y'
                AND primary_key = l.learner_id
                AND ROWNUM < 2) AS date_notified_deceased,
            mail_returned_date AS date_learner_mail_returned,
            (SELECT aud_date
               FROM (SELECT   *
                         FROM learner_aud
                     ORDER BY aud_date DESC)
              WHERE column_name = 'MAIL_RETURNED_DATE'
                AND primary_key = l.learner_id
                AND action = 'U'
                AND ROWNUM < 2) AS date_changed_mail_returned
       FROM learner l, learner_application lap, title ti
      WHERE l.learner_id = lap.learner_id
        AND lap.learner_application_id =
                                       (SELECT MAX (learner_application_id)
                                          FROM learner_application lap2
                                         WHERE lap2.learner_id = l.learner_id)
        AND ti.title_id = l.title_id
   ORDER BY l.learner_id ASC;


GRANT DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  VU_SDS TO EDM_USER;
