*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_UNAME
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Hardcoded user-name comparison.
*&
*& The current user is checked against a literal user ID instead of
*& through the SAP authorization concept. This bypasses roles,
*& authorization objects, the audit trail and any central governance.
*&
*& Detection token: "IF sy-uname ="  /  "sy-uname EQ"
*& See ZBC_SECURE_UNAME for the remediated version.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_uname.

START-OF-SELECTION.

* The whole access decision hinges on a string in the source code.
* If 'DEVELOPER1' is renamed, copied to another person, or the account
* is compromised, the critical action runs with no legitimate check.
  IF sy-uname = 'DEVELOPER1'.
    PERFORM critical_action.
  ELSE.
    WRITE: / 'Not authorized.'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  CRITICAL_ACTION
*&---------------------------------------------------------------------*
FORM critical_action.
  WRITE: / 'Critical action executed - WITHOUT an authority check.'.
ENDFORM.
