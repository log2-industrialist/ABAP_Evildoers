# Pattern 02 — Hardcoded client comparison (`IF sy-mandt = '…'`)

## The pattern

```abap
IF sy-mandt = '100'.
  PERFORM run_elevated_logic.
ENDIF.
```

Behaviour is switched on a literal client number baked into the source.

## Why it is dangerous

- **Breaks on client operations.** After a client copy or refresh (100 → 200), the logic silently changes or disappears. The code now behaves differently from what its author intended, with no error and no log.
- **Invisible environment logic.** "This only runs in the production client" is a meaningful business and security statement — but buried in an `IF`, it is invisible to configuration management, change control and audit.
- **Unmaintainable.** Changing the target client requires a code change and a transport instead of a configuration entry.
- **Often a smell for worse.** A `sy-mandt` gate frequently sits in front of something the developer did not want to run everywhere — exactly the kind of logic that deserves explicit governance, not a hidden literal.

Overall rating: **Medium** (higher when the gated logic is security-relevant).

## Detection

```
sy-mandt =
sy-mandt EQ
```

Triage: a `sy-mandt` used in a key or selection (legitimate, client-aware data access) is fine; a `sy-mandt` that *gates behaviour or an action* is the finding.

## Remediation

Drive the behaviour from maintained configuration. Two clean options:

1. **CTS selection variable (`TVARVC`, via `STVARV`)** — exists in every system, transportable, survives client copies. Used in the secure example.
2. **A dedicated client-dependent customizing table (SE11)** — for richer, multi-value logic, governed through the normal customizing process.

Either way the environment decision becomes transparent, auditable and changeable without touching code.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_MANDT.abap`](./ZBC_EVILDOER_MANDT.abap) | The anti-pattern (before) |
| [`ZBC_SECURE_MANDT.abap`](./ZBC_SECURE_MANDT.abap) | The remediated version (after) |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Locate gating `sy-mandt` comparisons, move the decision into TVARVC or a customizing table, document the intended client behaviour.
- **STAY_CLEAN:** Add the token to the ATC transport gate; state in the coding guidelines that client/environment logic belongs in configuration, never in a literal.
