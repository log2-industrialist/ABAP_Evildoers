*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_PASSWORD
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Credentials in clear text in the source.
*&
*& A user and password are written directly into the program. They are
*& now permanently readable by anyone with source access (developers,
*& admins, anyone who can read the transport), and they defeat password
*& rotation, central identity management and auditable credential
*& handling.
*&
*& Detection tokens: "PASSWORD", "PASSWD", "PWD =" and credential-like
*& literals near logon / connection calls.
*& See ZBC_SECURE_PASSWORD for the remediated approach.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_password.

DATA: lv_user TYPE string,
      lv_pass TYPE string.

START-OF-SELECTION.

* The secret lives in the source - and therefore in every transport,
* every backup and every version of this program forever.
  lv_user = 'RFCUSER'.
  lv_pass = 'PlaceholderSecret123'.

  PERFORM logon_to_remote_system USING lv_user lv_pass.

FORM logon_to_remote_system USING iv_user TYPE string
                                  iv_pass TYPE string.
  WRITE: / 'Logging on as', iv_user, '(secret taken from source).'.
ENDFORM.
