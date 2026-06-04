*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_MANDT
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Behaviour switched on a hardcoded client number.
*&
*& System or client specific logic is baked into the source via a
*& literal sy-mandt comparison. It is invisible to configuration,
*& breaks on client copies/refreshes and hides environment logic
*& from any governance process.
*&
*& Detection token: "sy-mandt ="  /  "sy-mandt EQ"
*& See ZBC_SECURE_MANDT for the remediated version.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_mandt.

START-OF-SELECTION.

* Whether the elevated logic runs depends on a magic number in the code.
* After a client copy from 100 to 200, this silently changes behaviour.
  IF sy-mandt = '100'.
    PERFORM run_elevated_logic.
  ELSE.
    PERFORM run_standard_logic.
  ENDIF.

FORM run_elevated_logic.
  WRITE: / 'Elevated logic - gated only by a hardcoded client.'.
ENDFORM.

FORM run_standard_logic.
  WRITE: / 'Standard logic.'.
ENDFORM.
