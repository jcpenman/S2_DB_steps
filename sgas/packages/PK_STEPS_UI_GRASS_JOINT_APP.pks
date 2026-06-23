CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_GRASS_JOINT_APP AS
/******************************************************************************
   NAME:       pk_steps_ui_grass_JOINT_APP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        26/01/2009      ABIRAMI CHIDAMBARAM   Created this package.
   ******************************************************************************/
    TYPE member_list_cursor      IS REF CURSOR;
      PROCEDURE getjointapplication (
      stud_session_id_in               IN              NUMBER,
      ja_case_out                      OUT NOCOPY      VARCHAR2,
      ja_stud_type_out                 OUT NOCOPY      VARCHAR2,
      total_saas_supported_out         OUT NOCOPY      NUMBER,
      total_non_saas_supported_out     OUT NOCOPY      NUMBER,
      joint_application_received_out   OUT NOCOPY      VARCHAR2,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   );
      PROCEDURE getjamemberslist (
      stud_session_id_in   IN              NUMBER,
      io_cursor            IN  OUT         member_list_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      temp_BEN1            OUT NOCOPY      NUMBER,
      temp_BEN2            OUT NOCOPY      NUMBER
      );
  
END PK_STEPS_UI_GRASS_JOINT_APP;
/
