CREATE OR REPLACE PACKAGE SGAS.pk_web_edocs
/*
 * Package code required for STEPS EDOCS processing
 *
 * Modification history:
 * 20.03.2012 Initial Version   Donald Crease
 *
 */
IS
   PROCEDURE pull_web_edocs;
v_max_date edm_complete.scan_date%type;    
   END pk_web_edocs;
/