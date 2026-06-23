-- VU_LEARNER_AUDIT.sql
-- Description: dbView to show all audit information held against a learner
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      13.10.08    R Hunter (SAAS)         Initial Version.
-- 1.1      14.10.08    A.Bowman (SAAS)         Added learner_duplicate_aud to dbview
-- 1.2      22.07.09    A.Bowman (SAAS)         Added Grants to allow this view to be added to the ILA500 Oracle Discoverer Business Area 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Views/VU_LEARNER_AUDIT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:46:57 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1295 $
DROP VIEW VU_LEARNER_AUDIT
/

/* Formatted on 2008/10/14 10:57 (Formatter Plus v4.8.8) */
--
-- VU_LEARNER_AUDIT  (View) 
--
CREATE OR REPLACE FORCE VIEW vu_learner_audit (learner_id,
                                               audit_type,
                                               aud_id,
                                               aud_date,
                                               column_name,
                                               primary_key,
                                               OLD,
                                               NEW,
                                               action,
                                               username
                                              )
AS
   SELECT a.learner_id, 'LEARNER AUDIT' audit_type, b."AUD_ID", b."AUD_DATE",
          b."COLUMN_NAME", b."PRIMARY_KEY", b."OLD", b."NEW", b."ACTION",
          b."USERNAME"
     FROM learner a, learner_aud b
    WHERE a.learner_id = b.primary_key
   UNION
   SELECT a.learner_id, 'LEARNER APPLICATION AUDIT' audit_type, d."AUD_ID",
          d."AUD_DATE", d."COLUMN_NAME", d."PRIMARY_KEY", d."OLD", d."NEW",
          d."ACTION", d."USERNAME"
     FROM learner a, learner_application c, learner_application_aud d
    WHERE a.learner_id = c.learner_id
      AND c.learner_application_id = d.primary_key
   UNION
   SELECT a.learner_id, 'LEARNER PAYMENT AUDIT' audit_type, f."AUD_ID",
          f."AUD_DATE", f."COLUMN_NAME", f."PRIMARY_KEY", f."OLD", f."NEW",
          f."ACTION", f."USERNAME"
     FROM learner a,
          learner_application c,
          learner_payment e,
          learner_payment_aud f
    WHERE a.learner_id = c.learner_id
      AND c.learner_application_id = e.learner_application_id
      AND e.learner_payment_id = f.primary_key
   UNION
   SELECT a.learner_id, 'LEARNER DUPLICATE AUDIT' audit_type, h."AUD_ID",
          h."AUD_DATE", h."COLUMN_NAME", h."PRIMARY_KEY", h."OLD", h."NEW",
          h."ACTION", h."USERNAME"
     FROM learner a, learner_duplicate g, learner_duplicate_aud h
    WHERE a.learner_id = g.learner_id
      AND g.learner_duplicate_id = h.primary_key
   UNION
   SELECT a.learner_id, 'CW NOTE AUDIT' audit_type, i."AUD_ID", i."AUD_DATE",
          i."COLUMN_NAME", i."PRIMARY_KEY", i."OLD", i."NEW", i."ACTION",
          i."USERNAME"
     FROM learner a, caseworker_note_aud i
    WHERE a.learner_id = i.primary_key
   UNION
   SELECT DISTINCT a.learner_id, 'DOC REG AUDIT' audit_type, j."AUD_ID",
                   j."AUD_DATE", j."COLUMN_NAME", j."PRIMARY_KEY", j."OLD",
                   j."NEW", j."ACTION", j."USERNAME"
              FROM learner a, document_register_aud j
             WHERE a.learner_id = j.primary_key
   UNION
   SELECT a.learner_id, 'EDM IMG AUDIT' audit_type, k."AUD_ID", k."AUD_DATE",
          k."COLUMN_NAME", k."PRIMARY_KEY", k."OLD", k."NEW", k."ACTION",
          k."USERNAME"
     FROM learner a, ila500_edm_images_aud k
    WHERE a.learner_id = k.primary_key
/

GRANT DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  VU_LEARNER_AUDIT TO EDM_USER;