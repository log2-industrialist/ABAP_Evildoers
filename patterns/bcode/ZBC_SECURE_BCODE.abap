*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_BCODE
*&---------------------------------------------------------------------*
*& REMEDIATION for the USR02-BCODE anti-pattern.
*&
*& Custom code never reads password hashes (BCODE, PASSCODE,
*& PWDSALTEDHASH). Authentication is delegated entirely to standard
*& SAP mechanisms.
*&
*& Legitimate, non-secret status questions (e.g. "is this user
*& locked?") use the appropriate non-hash fields only - shown here
*& with UFLAG.
*&---------------------------------------------------------------------*
REPORT zbc_secure_bcode.

DATA: lv_uflag TYPE usr02-uflag.

START-OF-SELECTION.

* No hash is ever touched. Only a non-secret status field is read.
  SELECT SINGLE uflag FROM usr02 INTO lv_uflag
    WHERE bname = sy-uname.

  IF sy-subrc = 0 AND lv_uflag IS INITIAL.
    WRITE: / 'User is not locked - status checked without any hash.'.
  ELSE.
    WRITE: / 'User is locked or unknown.'.
  ENDIF.
