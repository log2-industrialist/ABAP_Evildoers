*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_BREAK
*&---------------------------------------------------------------------*
*& REMEDIATION for the BREAK-POINT-in-production anti-pattern.
*&
*& The hard breakpoint is removed. Diagnostics that genuinely need to
*& ship are tied to a checkpoint group (transaction SAAB), which is
*& INACTIVE in production by default and can be activated temporarily
*& and per user without a transport.
*&
*& Prerequisite: create checkpoint group ZBC_DIAG in transaction SAAB.
*&---------------------------------------------------------------------*
REPORT zbc_secure_break.

START-OF-SELECTION.

  PERFORM process_business_data.

* Ships safely: produces nothing unless ZBC_DIAG is explicitly
* activated; never halts the transaction.
  LOG-POINT ID zbc_diag
    FIELDS sy-uname sy-datum sy-uzeit.

  PERFORM post_processing.

FORM process_business_data.
  WRITE: / 'Processing...'.
ENDFORM.

FORM post_processing.
  WRITE: / 'Done.'.
ENDFORM.
