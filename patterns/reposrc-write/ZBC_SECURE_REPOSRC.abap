*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_REPOSRC
*&---------------------------------------------------------------------*
*& The only legitimate code-level use of REPOSRC is READ access - and
*& even that is rarely needed, since source is visible via SE38/SE80.
*& WRITING to REPOSRC from code is never allowed: all source changes go
*& exclusively through SE80/ADT and the transport system.
*&
*& This example performs a harmless, read-only existence check. No
*& Native SQL, no write of any kind.
*&---------------------------------------------------------------------*
REPORT zbc_secure_reposrc.

DATA: lv_prog TYPE reposrc-progname.

START-OF-SELECTION.

  SELECT SINGLE progname FROM reposrc INTO lv_prog
    WHERE progname = 'SAPLSE38'.

  IF sy-subrc = 0.
    WRITE: / 'Read-only check ok:', lv_prog.
  ELSE.
    WRITE: / 'Program not found.'.
  ENDIF.
