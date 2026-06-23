CREATE OR REPLACE PACKAGE SGAS.PK_GENERAL_LOCKING
AS
   /******************************************************************************
      NAME:       PK_GENERAL_LOCKING
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/04/2019  James Baird       1. Created this package.
   ******************************************************************************/

   PROCEDURE islocked (username_in         IN            VARCHAR2,
                       reference_type_in   IN            VARCHAR2,
                       reference_id_in     IN            VARCHAR2,
                       locked_status          OUT NOCOPY VARCHAR2,
                       locked_message         OUT NOCOPY VARCHAR2,
                       locked_by              OUT NOCOPY VARCHAR2);


   PROCEDURE lockrecord (username_in         IN            VARCHAR2,
                         reference_type_in   IN            VARCHAR2,
                         reference_id_in     IN            VARCHAR2,
                         locked_status          OUT NOCOPY VARCHAR2,
                         locked_message         OUT NOCOPY VARCHAR2);

   PROCEDURE unlockrecord (username_in         IN            VARCHAR2,
                           reference_type_in   IN            VARCHAR2,
                           reference_id_in     IN            VARCHAR2,
                           locked_status          OUT NOCOPY VARCHAR2,
                           locked_message         OUT NOCOPY VARCHAR2);

   PROCEDURE unlockallrecords (username_in IN VARCHAR2);

   FUNCTION get_employee_name (username_in IN VARCHAR2)
      RETURN VARCHAR2;
END PK_GENERAL_LOCKING;
/