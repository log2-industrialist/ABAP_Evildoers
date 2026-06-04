*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_REPOSRC
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Writing to the repository source table REPOSRC.
*&
*& DETECTION FIXTURE - read this header.
*& REPOSRC holds the uncompiled source of ABAP programs. The kernel
*& forbids any WRITE to it; the only way to force one is Native SQL
*& (EXEC SQL) or a similar bypass. A successful write can overwrite the
*& source of OTHER programs OUTSIDE the transport system - an ideal,
*& hard-to-detect backdoor / sabotage mechanism.
*&
*& Because any actual write to REPOSRC is destructive by nature, this
*& repository documents the pattern as a DETECTION SIGNATURE only and
*& does NOT ship a runnable write. The forbidden statement appears below
*& as a NON-EXECUTABLE, commented illustration so a source scanner can
*& be calibrated against the tokens.
*&
*& Detection tokens: EXEC SQL ... REPOSRC ... (UPDATE / INSERT / MODIFY)
*& See ZBC_SECURE_REPOSRC for the only legitimate (read-only) use.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_reposrc.

START-OF-SELECTION.

* ---------------------------------------------------------------------
* NON-EXECUTABLE ILLUSTRATION (intentionally commented out).
* The following is the forbidden pattern a scanner must flag - it
* bypasses every SAP protection mechanism and the transport system:
*
*   EXEC SQL.
*     UPDATE REPOSRC SET DATA = ... WHERE PROGNAME = '...'.
*   ENDEXEC.
*
* Source code must only ever be changed through SE80/ADT and transports.
* ---------------------------------------------------------------------

  WRITE: / 'Detection fixture only - no repository write is performed.'.
