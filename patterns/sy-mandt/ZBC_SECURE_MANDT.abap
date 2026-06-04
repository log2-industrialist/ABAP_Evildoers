*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_MANDT
*&---------------------------------------------------------------------*
*& REMEDIATION for the hardcoded sy-mandt anti-pattern.
*&
*& Environment / client specific behaviour is driven by maintained
*& configuration instead of a literal in the code. Here: a CTS
*& selection variable (table TVARVC, maintained via STVARV), which
*& exists in every system and survives client copies cleanly.
*&
*& For richer logic, a dedicated customizing table (SE11, client
*& dependent) is the equivalent clean approach.
*&---------------------------------------------------------------------*
REPORT zbc_secure_mandt.

DATA: lv_flag TYPE tvarvc-low.

START-OF-SELECTION.

  SELECT SINGLE low FROM tvarvc INTO lv_flag
    WHERE name = 'ZBC_ELEVATED_LOGIC'
      AND type = 'P'.

  IF sy-subrc = 0 AND lv_flag = 'X'.
    PERFORM run_elevated_logic.
  ELSE.
    PERFORM run_standard_logic.
  ENDIF.

FORM run_elevated_logic.
  WRITE: / 'Elevated logic - gated by maintained configuration.'.
ENDFORM.

FORM run_standard_logic.
  WRITE: / 'Standard logic.'.
ENDFORM.
