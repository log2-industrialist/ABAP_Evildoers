# Pattern 05 — Hardcoded passwords

## The pattern

```abap
lv_user = 'RFCUSER'.
lv_pass = 'PlaceholderSecret123'.
```

Credentials written in clear text directly into the source.

## Why it is dangerous

A hardcoded password is a serious security risk:

- **Permanently exposed.** The secret is readable by every developer and admin with source access — and it lives on in every transport, backup and program version, effectively forever.
- **Enables privilege abuse.** Anyone who reads it can authenticate as that user, bypass intended controls and reach the systems and data the account can touch.
- **Defeats credential hygiene.** Password rotation, central identity management and auditable credential handling all become impossible the moment the secret is frozen into code.
- **Violates accepted standards.** It runs against BSI and OWASP guidance and is, for a production system, plainly critical.

Overall rating: **High**.

## Detection

```
PASSWORD
PASSWD
PWD
```

Plus credential-like string literals in the vicinity of logon, RFC or connection calls. Triage separates harmless uses of the word (field labels, comments) from actual secrets assigned to logon parameters.

## Remediation

Remove every hardcoded secret. Use a mechanism appropriate to the case:

- **Connections (RFC/HTTP):** keep the logon data in the **SM59 destination** and let the runtime supply it (`CALL FUNCTION … DESTINATION`, `CREATE_BY_DESTINATION`). No secret in code — see the secure example.
- **Application-level secrets:** use **SAP Secure Storage** (in the database) or a central secret-management system, referenced at runtime — never written into the source.
- **Technical users:** provision them with strictly scoped authorizations so a leaked credential has limited blast radius.

Existing hardcoded secrets must be replaced as fast as possible, and the affected accounts/systems checked for compromise — because the secret may already have been read.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_PASSWORD.abap`](./ZBC_EVILDOER_PASSWORD.abap) | The anti-pattern (before) |
| [`ZBC_SECURE_PASSWORD.abap`](./ZBC_SECURE_PASSWORD.abap) | The remediated approach (after) |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Find hardcoded credentials, move them to destinations / secure storage, then rotate the exposed secrets and check for misuse.
- **STAY_CLEAN:** Token in the ATC transport gate; guidelines forbid secrets in source; technical-user accounts kept least-privilege.
