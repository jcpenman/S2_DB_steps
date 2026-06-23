-- VU_PROVIDER_AUDIT.sql
-- Description: dbView to show all audit information held against a provider
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.10.08    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $
DROP VIEW VU_PROVIDER_AUDIT
/


/* Formatted on 2008/10/14 11:04 (Formatter Plus v4.8.8) */
--
-- VU_PROVIDER_AUDIT  (View) 
--
CREATE OR REPLACE VIEW vu_provider_audit (provider_id,
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
   (SELECT a.provider_id, 'PROVIDER AUDIT' audit_type, b."AUD_ID",
           b."AUD_DATE", b."COLUMN_NAME", b."PRIMARY_KEY", b."OLD", b."NEW",
           b."ACTION", b."USERNAME"
      FROM provider a, provider_aud b
     WHERE a.provider_id = b.primary_key
    UNION
    SELECT a.provider_id, 'PROVIDER PAYMENT AUDIT' audit_type, d."AUD_ID",
           d."AUD_DATE", d."COLUMN_NAME", d."PRIMARY_KEY", d."OLD", d."NEW",
           d."ACTION", d."USERNAME"
      FROM provider a, provider_payment c, provider_payment_aud d
     WHERE a.provider_id = c.provider_id
       AND c.provider_payment_id = d.primary_key
    UNION
    SELECT a.provider_id, 'REPORT HISTORY AUDIT' audit_type, f."AUD_ID",
           f."AUD_DATE", f."COLUMN_NAME", f."PRIMARY_KEY", f."OLD", f."NEW",
           f."ACTION", f."USERNAME"
      FROM provider a, report_history e, report_history_aud f
     WHERE a.provider_id = e.provider_id AND e.rep_hist_id = f.primary_key
    UNION
    SELECT a.provider_id, 'CW NOTE AUDIT' audit_type, g."AUD_ID",
           g."AUD_DATE", g."COLUMN_NAME", g."PRIMARY_KEY", g."OLD", g."NEW",
           g."ACTION", g."USERNAME"
      FROM provider a, caseworker_note_aud g
     WHERE a.provider_id = g.primary_key
    UNION
    SELECT a.provider_id, 'DOC REG AUDIT' audit_type, h."AUD_ID",
           h."AUD_DATE", h."COLUMN_NAME", h."PRIMARY_KEY", h."OLD", h."NEW",
           h."ACTION", h."USERNAME"
      FROM provider a, document_register_aud h
     WHERE a.provider_id = h.primary_key)
/