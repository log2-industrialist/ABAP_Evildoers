*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_SYSCMD
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: OS command execution via the deprecated kernel call
*& CALL 'SYSTEM'.
*&
*& DETECTION FIXTURE - read this header.
*& This program carries the deprecated CALL 'SYSTEM' token so a source
*& scanner / ATC pattern can be calibrated against it. It runs a FIXED,
*& HARMLESS command and is deliberately NOT driven by any PARAMETERS or
*& external input. The real danger of this pattern is OS command
*& INJECTION - sourcing the command from user input - which this
*& repository intentionally does NOT demonstrate.
*&
*& SAP has deprecated this call for custom reports. On a hardened system
*& it is blocked via profile parameter rdisp/call_system.
*&
*& Detection token: CALL 'SYSTEM'
*& See ZBC_SECURE_SYSCMD for the sanctioned replacement.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_syscmd.

DATA: lt_result TYPE TABLE OF char255,
      lv_cmd    TYPE char255.

START-OF-SELECTION.

* Fixed, harmless command. Never parameterize this with external input.
  lv_cmd = 'echo abap-evildoers-detection-marker'.

  CALL 'SYSTEM' ID 'COMMAND' FIELD lv_cmd
                ID 'TAB'     FIELD lt_result[].

  WRITE: / 'Deprecated kernel call executed (detection fixture).'.
