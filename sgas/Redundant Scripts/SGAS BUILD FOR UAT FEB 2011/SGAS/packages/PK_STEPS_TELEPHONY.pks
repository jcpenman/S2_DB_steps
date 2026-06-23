/* Formatted on 2009/11/20 09:48 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_telephony
AS
-- DESCRIPTION
-- ===========
-- Package contains procedure to create the file for telephony
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 18.11.2009           R.Hunter    001    Initial Creation of Package
-- 19.11.2009           A.Bowman    002    Added clear_telephony procedure
-- 20.11.2009           A.Bowman    003    Added receive_telephony_file procedure
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE create_telephony_file (
      PATH            IN       VARCHAR2,
      filename        IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE send_telephony_file (
      error_boolean   OUT   VARCHAR2,
      ERROR_TEXT      OUT   VARCHAR2
   );

   /*PROCEDURE clear_telephony;*/

   PROCEDURE receive_telephony_file (
      error_boolean   OUT   VARCHAR2,
      ERROR_TEXT      OUT   VARCHAR2
   );

END pk_steps_telephony;
/