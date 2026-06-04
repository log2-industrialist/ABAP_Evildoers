*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_SYSCMD
*&---------------------------------------------------------------------*
*& REMEDIATION for the CALL 'SYSTEM' anti-pattern.
*&
*& External commands are run via the sanctioned function module
*& SXPG_COMMAND_EXECUTE, which:
*&   - executes only PREDEFINED logical commands maintained in SM69,
*&   - never a free-form OS string from user input,
*&   - is protected by authorization object S_LOG_COM,
*&   - is logged.
*&
*& Prerequisite: define the logical command (here 'ZBC_LS') in SM69.
*&---------------------------------------------------------------------*
REPORT zbc_secure_syscmd.

DATA: lt_protocol TYPE TABLE OF btcxpm,
      lv_status   TYPE c LENGTH 1.

START-OF-SELECTION.

  CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
    EXPORTING
      commandname         = 'ZBC_LS'          " predefined in SM69
      operatingsystem     = sy-opsys
    IMPORTING
      status              = lv_status
    TABLES
      exec_protocol       = lt_protocol
    EXCEPTIONS
      no_permission       = 1
      command_not_found   = 2
      parameters_too_long = 3
      security_risk       = 4
      program_start_error = 5
      x_error             = 6
      OTHERS              = 7.

  IF sy-subrc = 0.
    WRITE: / 'Command executed via SXPG (status', lv_status, ').'.
  ELSE.
    WRITE: / 'SXPG call failed, sy-subrc =', sy-subrc.
  ENDIF.
