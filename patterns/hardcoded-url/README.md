# Pattern 04 — Hardcoded URL (`CREATE_BY_URL`)

## The pattern

```abap
cl_http_client=>create_by_url(
  EXPORTING url    = 'http://external.example.com/data'
  IMPORTING client = lo_http_client ).
```

An external service is addressed by a fixed URL written directly into the source.

## Why it is dangerous

- **No central management.** A hardcoded URL cannot be governed centrally or restricted to trusted systems. If the target changes — or is changed maliciously — data can flow out unnoticed.
- **Weak or absent transport security.** Without explicit TLS and certificate handling (and `http://` in the example says it all), the connection can be intercepted or manipulated.
- **Bypasses the security perimeter.** Direct calls from code skip the central interfaces, proxies and gateways that are supposed to handle authentication, logging and monitoring.
- **No governance, no flexibility.** Certificate, header or endpoint-policy changes cannot be rolled out centrally; each one becomes a code change and a transport.

Overall rating: **Medium** (higher when sensitive data crosses the connection or `http://` is used).

## Detection

```
create_by_url
```

Triage: every hit is worth review. Internal, non-sensitive calls may be acceptable; external endpoints, anything over `http://`, and anything carrying sensitive data are findings.

## Remediation

Address the connection through an **RFC destination** (`SM59`, type G for HTTP or H for HTTPS) using `CREATE_BY_DESTINATION`:

```abap
cl_http_client=>create_by_destination(
  EXPORTING destination = 'ZBC_EXTERNAL_API'
  IMPORTING client      = lo_http_client
  EXCEPTIONS OTHERS     = 6 ).
```

Endpoint, TLS, certificates, proxy and authentication now live in the destination, managed and audited centrally and changeable without touching code. This is the approach recommended by SAP best practice and BSI guidance: destinations, communication arrangements, or central middleware instead of inline URLs.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_URL.abap`](./ZBC_EVILDOER_URL.abap) | The anti-pattern (before) |
| [`ZBC_SECURE_URL.abap`](./ZBC_SECURE_URL.abap) | The remediated version (after) |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Replace `CREATE_BY_URL` calls to external/sensitive endpoints with `CREATE_BY_DESTINATION` plus a maintained SM59 destination.
- **STAY_CLEAN:** Add the token to the ATC transport gate; coding guidelines require destinations for outbound connections.
