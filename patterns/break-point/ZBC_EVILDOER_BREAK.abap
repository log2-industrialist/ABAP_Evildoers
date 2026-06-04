*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_BREAK
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Hard BREAK-POINT left in productive code.
*&
*& A static BREAK-POINT halts execution for any user with debug
*& authorization, mid-transaction. It is a development tool that must
*& never survive into a production system.
*&
*& Detection token: "BREAK-POINT"  /  "BREAK <username>"
*& See ZBC_SECURE_BREAK for the remediated version.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_break.

START-OF-SELECTION.

  PERFORM process_business_data.

* This stops the running business transaction dead for anyone with
* debug rights - a denial-of-service and a window into live data.
  BREAK-POINT.

  PERFORM post_processing.

FORM process_business_data.
  WRITE: / 'Processing...'.
ENDFORM.

FORM post_processing.
  WRITE: / 'Done.'.
ENDFORM.
