CREATE OR REPLACE PACKAGE SGAS.Edm_Info
  IS
--
  TYPE t_cursor IS REF CURSOR;

  FUNCTION GetCollatedDocTypes
  RETURN t_cursor;
--
END;
/

