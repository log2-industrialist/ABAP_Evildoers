*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_BCODE
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Reading / evaluating the legacy USR02-BCODE hash.
*&
*& USR02-BCODE holds an outdated, cryptographically weak password hash.
*& Custom code that reads or processes it pulls authentication logic
*& into application logic, exposes a weak hash to offline attack and
*& can undermine modern authentication controls.
*&
*& Detection tokens: "BCODE", "USR02" with hash fields
*& See ZBC_SECURE_BCODE for the remediated approach.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_bcode.

DATA: lv_bcode TYPE usr02-bcode.

START-OF-SELECTION.

* There is no legitimate reason for custom code to read a password
* hash. Doing so exposes a weak, attackable artefact.
  SELECT SINGLE bcode FROM usr02 INTO lv_bcode
    WHERE bname = sy-uname.

  IF sy-subrc = 0.
    WRITE: / 'Read a legacy password hash into application logic.'.
  ENDIF.
