*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_UNAME
*&---------------------------------------------------------------------*
*& REMEDIATION for the hardcoded sy-uname anti-pattern.
*&
*& The access decision is made by the SAP authorization concept via
*& AUTHORITY-CHECK against a custom authorization object. Access is now:
*&   - role based and assignable without code changes
*&   - auditable (visible in SU53, ST01, security audit log)
*&   - centrally governed
*&
*& Prerequisite: create authorization object Z_CRIT_ACT in SU21 with
*& field ACTVT (activity). '16' = Execute.
*&---------------------------------------------------------------------*
REPORT zbc_secure_uname.

START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'Z_CRIT_ACT'
    ID 'ACTVT' FIELD '16'.

  IF sy-subrc = 0.
    PERFORM critical_action.
  ELSE.
*   Fail closed: no authorization means no execution.
    MESSAGE 'No authorization for this action.' TYPE 'E'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  CRITICAL_ACTION
*&---------------------------------------------------------------------*
FORM critical_action.
  WRITE: / 'Critical action executed - after a proper authority check.'.
ENDFORM.
