/* Formatted on 2011/01/07 17:45 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_bene_dets
AS
/******************************************************************************
   NAME:       pk_steps_ui_BENE_DETS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        05/02/2009      ABIRAMI CHIDAMBARAM   Code Population
   1.2        13/07/2010      Paddy Grace           Code amendment
******************************************************************************/
   TYPE bendep_cursor IS REF CURSOR;

   TYPE checkdup_cursor IS REF CURSOR;

   PROCEDURE getbendetails (
      stud_session_id_in   IN              VARCHAR2,
      ben1_id              OUT NOCOPY      VARCHAR2,
      ben1_rel_id          OUT NOCOPY      VARCHAR2,
      ben2_id              OUT NOCOPY      VARCHAR2,
      ben2_rel_id          OUT NOCOPY      VARCHAR2,
      session_code         OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setbendetails (
      stud_session_id_in   IN              VARCHAR2,
      ben1_id_in           IN              VARCHAR2,
      ben1_rel_id_in       IN              VARCHAR2,
      ben2_id_in           IN              VARCHAR2,
      ben2_rel_id_in       IN              VARCHAR2,
      user_in              IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getgrassbenefactor (
      ben_id_in       IN              VARCHAR2,
      title           OUT NOCOPY      VARCHAR2,
      nino            OUT NOCOPY      VARCHAR2,
      initials        OUT NOCOPY      VARCHAR2,
      forenames       OUT NOCOPY      VARCHAR2,
      surname         OUT NOCOPY      VARCHAR2,
      house_no_name   OUT NOCOPY      VARCHAR2,
      addr_l1         OUT NOCOPY      VARCHAR2,
      addr_l2         OUT NOCOPY      VARCHAR2,
      addr_l3         OUT NOCOPY      VARCHAR2,
      addr_l4         OUT NOCOPY      VARCHAR2,
      post_code       OUT NOCOPY      VARCHAR2,
      mailsort        OUT NOCOPY      VARCHAR2,
      tele_no         OUT NOCOPY      VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getbenefactor (
      ben_id_in       IN              VARCHAR2,
      title           OUT NOCOPY      VARCHAR2,
      nino            OUT NOCOPY      VARCHAR2,
      initials        OUT NOCOPY      VARCHAR2,
      forenames       OUT NOCOPY      VARCHAR2,
      surname         OUT NOCOPY      VARCHAR2,
      house_no_name   OUT NOCOPY      VARCHAR2,
      addr_l1         OUT NOCOPY      VARCHAR2,
      addr_l2         OUT NOCOPY      VARCHAR2,
      addr_l3         OUT NOCOPY      VARCHAR2,
      addr_l4         OUT NOCOPY      VARCHAR2,
      post_code       OUT NOCOPY      VARCHAR2,
      mailsort        OUT NOCOPY      VARCHAR2,
      tele_no         OUT NOCOPY      VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setbenefactor (
      ben_id_in          IN              VARCHAR2,
      title_in           IN              VARCHAR2,
      nino_in            IN              VARCHAR2,
      initials_in        IN              VARCHAR2,
      forenames_in       IN              VARCHAR2,
      surname_in         IN              VARCHAR2,
      house_no_name_in   IN              VARCHAR2,
      addr_l1_in         IN              VARCHAR2,
      addr_l2_in         IN              VARCHAR2,
      addr_l3_in         IN              VARCHAR2,
      addr_l4_in         IN              VARCHAR2,
      post_code_in       IN              VARCHAR2,
      mailsort_in        IN              VARCHAR2,
      tele_no_in         IN              VARCHAR2,
      user_in            IN              VARCHAR2,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertbenefactor (
      stud_session_id_in     IN              VARCHAR2,
      benefactor_number_in   IN              VARCHAR2,
      relationship_in        IN              VARCHAR2,
      title_in               IN              VARCHAR2,
      nino_in                IN              VARCHAR2,
      initials_in            IN              VARCHAR2,
      forenames_in           IN              VARCHAR2,
      surname_in             IN              VARCHAR2,
      house_no_name_in       IN              VARCHAR2,
      addr_l1_in             IN              VARCHAR2,
      addr_l2_in             IN              VARCHAR2,
      addr_l3_in             IN              VARCHAR2,
      addr_l4_in             IN              VARCHAR2,
      post_code_in           IN              VARCHAR2,
      mailsort_in            IN              VARCHAR2,
      tele_no_in             IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE removebenefactor (
      stud_session_id_in   IN              VARCHAR2,
      benefactor_number    IN              VARCHAR2,
      user_in              IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE checkduplicatebenefactor (
      forename_in     IN       VARCHAR2,
      surname_in      IN       VARCHAR2,
      io_cursor       IN OUT   checkdup_cursor,
      row_count       OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getbenefactordependants (
      stud_session_id_in   IN              NUMBER,
      io_cursor            IN OUT          bendep_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertbenefactordependants (
      stud_session_id_in   IN       VARCHAR2,
      dob_in               IN       DATE,
      rel_type_in          IN       VARCHAR2,
      user_in              IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   );

   PROCEDURE removebenefactordependants (
      bed_id_in       IN       VARCHAR2,
      user_in         IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );
END pk_steps_ui_bene_dets;
/