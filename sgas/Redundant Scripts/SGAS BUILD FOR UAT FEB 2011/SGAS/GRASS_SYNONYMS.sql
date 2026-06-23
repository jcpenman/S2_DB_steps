-- Script to create public synonyms for GRASS tables that have equivalents in STEPS.
-- Each synonym will be named GRASS_<tablename>
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--          16/03/2008  R Hunter (SAAS)         Added campus
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/GRASS_SYNONYMS.sql $
-- $Author: SDurkin$
-- $Date: 2009-04-08 13:42:41 +0100 (Wed, 08 Apr 2009) $
-- $Revision: 2750 $

DROP PUBLIC SYNONYM grass_telephony
/
CREATE PUBLIC SYNONYM grass_telephony       FOR telephony@GRASS
/

DROP PUBLIC SYNONYM grass_stud_crse_year
/
CREATE PUBLIC SYNONYM grass_stud_crse_year  FOR stud_crse_year@GRASS
/

DROP PUBLIC SYNONYM grass_stud_home_addr
/
CREATE PUBLIC SYNONYM grass_stud_home_addr  FOR stud_home_addr@GRASS
/

DROP PUBLIC SYNONYM grass_stud_term_addr
/
CREATE PUBLIC SYNONYM grass_stud_term_addr  FOR stud_term_addr@GRASS
/

DROP PUBLIC SYNONYM grass_stud_app_prog
/
CREATE PUBLIC SYNONYM grass_stud_app_prog   FOR stud_app_prog@GRASS
/

DROP PUBLIC SYNONYM grass_stud
/
CREATE PUBLIC SYNONYM grass_stud            FOR stud@GRASS
/

DROP PUBLIC SYNONYM campus
/
create public synonym campus for campus@grass
/