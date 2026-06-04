*&---------------------------------------------------------------------*
*& Report ZBC_EVILDOER_URL
*&---------------------------------------------------------------------*
*& ANTI-PATTERN: Hardcoded external URL via CREATE_BY_URL.
*&
*& An external service is addressed by a fixed URL in the source. This
*& bypasses central connection management (SM59), proxies and security
*& gateways, and hardcodes TLS / certificate / endpoint policy into
*& code that can only be changed by a transport.
*&
*& Detection token: "create_by_url"
*& See ZBC_SECURE_URL for the remediated version.
*&---------------------------------------------------------------------*
REPORT zbc_evildoer_url.

DATA: lo_http_client TYPE REF TO if_http_client.

START-OF-SELECTION.

* Endpoint, transport security and trust are all decided here, in code.
  cl_http_client=>create_by_url(
    EXPORTING
      url                = 'http://external.example.com/data'
    IMPORTING
      client             = lo_http_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  IF sy-subrc <> 0.
    WRITE: / 'Client creation failed.'.
    RETURN.
  ENDIF.

  lo_http_client->send( EXCEPTIONS OTHERS = 1 ).
  lo_http_client->receive( EXCEPTIONS OTHERS = 1 ).
