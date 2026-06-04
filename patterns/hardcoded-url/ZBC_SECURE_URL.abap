*&---------------------------------------------------------------------*
*& Report ZBC_SECURE_URL
*&---------------------------------------------------------------------*
*& REMEDIATION for the hardcoded-URL anti-pattern.
*&
*& The connection is addressed through an RFC destination (SM59, type
*& G/H). Endpoint, TLS, certificates, proxy and authentication are all
*& configured and governed centrally - and can be changed without a
*& code change or transport.
*&
*& Prerequisite: maintain destination ZBC_EXTERNAL_API in SM59.
*&---------------------------------------------------------------------*
REPORT zbc_secure_url.

DATA: lo_http_client TYPE REF TO if_http_client.

START-OF-SELECTION.

  cl_http_client=>create_by_destination(
    EXPORTING
      destination              = 'ZBC_EXTERNAL_API'
    IMPORTING
      client                   = lo_http_client
    EXCEPTIONS
      argument_not_found       = 1
      destination_not_found    = 2
      destination_no_authority = 3
      plugin_not_active        = 4
      internal_error           = 5
      OTHERS                   = 6 ).

  IF sy-subrc <> 0.
    WRITE: / 'Client creation failed.'.
    RETURN.
  ENDIF.

  lo_http_client->send( EXCEPTIONS OTHERS = 1 ).
  lo_http_client->receive( EXCEPTIONS OTHERS = 1 ).
