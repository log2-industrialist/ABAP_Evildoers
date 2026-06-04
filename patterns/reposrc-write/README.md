# Pattern 08 — Writing to the repository source (`REPOSRC`)

> **Detection + remediation entry.** Any real write to REPOSRC is destructive, so the forbidden statement is shipped only as a non-executable, commented illustration for scanner calibration — never as a runnable write.

## The pattern

```abap
EXEC SQL.
  UPDATE REPOSRC SET DATA = ... WHERE PROGNAME = '...'.
ENDEXEC.
```

`REPOSRC` holds the uncompiled source of the ABAP programs in the system. Reading it is technically possible and usually harmless; **writing** to it is forbidden by the SAP standard and can only be forced through Native SQL (`EXEC SQL`) or a comparable bypass.

## Why it is dangerous

While a read poses little risk (source is visible via SE38/SE80 anyway), a **write** is extremely dangerous:

- **Stealth tampering.** A write can overwrite other programs' source — injecting a backdoor or silently replacing whole reports.
- **Invisible to governance.** Changes made this way happen outside the transport system, so they appear in no transport request, no Workbench documentation and no version history. That makes them an ideal hard-to-detect backdoor or sabotage mechanism.
- **Strong malicious indicator.** SAP explicitly write-protects REPOSRC; using `EXEC SQL` to defeat that protection is a strong signal of either malicious manipulation or a grave design error.

The likelihood is technically bounded (the developer needs Native-SQL authorization), but the impact is maximal: arbitrary program modification, hidden malicious code, removal of security checks, or system-wide destabilization. Overall rating: **Very high**.

## Detection

```
EXEC SQL          (in proximity to)  REPOSRC
UPDATE REPOSRC
INSERT REPOSRC
MODIFY REPOSRC
```

A text scan (e.g. `RS_ABAP_SOURCE_SCAN`) flags the tokens even in comments — which is exactly why the detection fixture keeps the forbidden statement in a comment. Any write occurrence is a critical finding.

## Remediation

- Remove every write access to REPOSRC. Forbid `EXEC SQL` / Native SQL against repository tables outright.
- Source changes go **only** through the intended SAP tools (SE80/ADT), the transport system and regular development processes.
- Programs that attempted a REPOSRC write are identified in GET_CLEAN and switched off or rebuilt properly.
- Grant Native-SQL authorizations only where strictly necessary, and monitor them.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_REPOSRC.abap`](./ZBC_EVILDOER_REPOSRC.abap) | Detection fixture (forbidden write shown commented, non-executable) |
| [`ZBC_SECURE_REPOSRC.abap`](./ZBC_SECURE_REPOSRC.abap) | The only legitimate use: read-only access |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Identify and eliminate all REPOSRC writes; tighten Native-SQL authorizations.
- **STAY_CLEAN:** Coding guidelines explicitly ban updates to SAP repository tables; the tokens go into the ATC transport gate and automated scans.
