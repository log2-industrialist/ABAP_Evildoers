# Pattern 06 — Reading the legacy password hash (`USR02-BCODE`)

## The pattern

```abap
SELECT SINGLE bcode FROM usr02 INTO lv_bcode
  WHERE bname = sy-uname.
```

Custom code reads or evaluates `USR02-BCODE` — the outdated SAP password hash.

## Why it is dangerous

`USR02-BCODE` holds a password hash based on old, cryptographically weak algorithms. Pulling it into custom code is a problem on several levels:

- **Weak hash, offline attack.** BCODE hashes are comparatively easy to attack with today's methods. Exposing them — even internally — invites offline password reconstruction.
- **Wrong layer.** Processing password hashes in application code violates the separation of authentication logic from application logic. Authentication is the platform's job, not the custom report's.
- **Undermines modern controls.** Using BCODE can sidestep or weaken stronger hashing, multi-factor authentication and central authentication services.
- **Compliance exposure.** SAP has classified BCODE as insecure for a long time; relying on it risks breaching internal policy and regulatory requirements.

Overall rating: **High**.

## Detection

```
BCODE
USR02
```

Triage: reading non-secret USR02 fields (lock status `UFLAG`, validity dates) is legitimate; reading or comparing any hash field (`BCODE`, `PASSCODE`, `PWDSALTEDHASH`) is the finding.

## Remediation

Adjust custom code so it never reads or evaluates `USR02` hash fields. Authentication and password handling go exclusively through standard, supported SAP mechanisms. If a password check is genuinely required, it uses standard SAP interfaces — never the raw hash. The secure example shows the principle: a legitimate, non-secret status check (`UFLAG`) instead of touching a hash.

Additionally, verify whether BCODE hashes are still actively used in the system at all, and if so, migrate to modern password hashing (`CODVN`) and enable stronger controls (MFA, strong password policy). Recurring security and code reviews keep the pattern out.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_BCODE.abap`](./ZBC_EVILDOER_BCODE.abap) | The anti-pattern (before) |
| [`ZBC_SECURE_BCODE.abap`](./ZBC_SECURE_BCODE.abap) | The remediated approach (after) |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Remove all custom access to USR02 hash fields; confirm CODVN status and migrate away from weak hashes.
- **STAY_CLEAN:** Token in the ATC transport gate; guidelines forbid custom processing of password hashes outright.
