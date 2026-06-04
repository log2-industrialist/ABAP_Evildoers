*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_PASSWORD
*&---------------------------------------------------------------------*
*& REMEDIATION for the hardcoded-credentials anti-pattern.
*&
*& No credentials appear in the code at all. For a connection, the
*& logon data is held in the SM59 destination and supplied by the
*& runtime - managed centrally, outside the source and the transport.
*&
*& For application level secrets that are not tied to a destination,
*& use SAP Secure Storage (in the database) or a central secret
*& management system - never a literal in the source.
*&
*& Prerequisite: maintain destination ZBC_REMOTE in SM59 with its
*& logon data; implement RFM Z_REMOTE_READ in the target system.
*&---------------------------------------------------------------------*
REPORT zbc_secure_password.

DATA: lt_result TYPE TABLE OF string.

START-OF-SELECTION.

  CALL FUNCTION 'Z_REMOTE_READ'
    DESTINATION 'ZBC_REMOTE'
    TABLES
      result                = lt_result
    EXCEPTIONS
      communication_failure = 1
      system_failure        = 2
      OTHERS                = 3.

  IF sy-subrc = 0.
    WRITE: / 'Read', lines( lt_result ), 'rows - no secret in code.'.
  ELSE.
    WRITE: / 'Remote call failed:', sy-subrc.
  ENDIF.
