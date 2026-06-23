CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_recordlocking
AS

   PROCEDURE islocked (
      reference_id_in   IN              VARCHAR2,
      islocked          OUT NOCOPY      number
   );

   PROCEDURE isexpired (
      reference_id_in   IN              VARCHAR2,
      isexpired         OUT NOCOPY      number
   );

   PROCEDURE isowned (
      reference_id_in   IN              VARCHAR2,
      employee_in       IN              VARCHAR2,
      isowned           OUT NOCOPY      number
   );

   PROCEDURE getowner (
      reference_id_in   IN              VARCHAR2,
      owner_out         OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE updatettl (reference_id_in IN VARCHAR2);   

   PROCEDURE lockrecord (reference_id_in IN VARCHAR2, employee_in IN VARCHAR2, reference_id_type_in IN VARCHAR2);

   PROCEDURE unlockrecord (reference_id_in IN VARCHAR2, employee_in in varchar2);
   
   PROCEDURE unlockallrecords (employee_in IN VARCHAR2);
   
END pk_steps_ui_recordlocking;
/
