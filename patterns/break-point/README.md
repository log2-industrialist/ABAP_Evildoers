# Pattern 03 — `BREAK-POINT` in production code

## The pattern

```abap
BREAK-POINT.
```

A static breakpoint (or the user-specific `BREAK <username>`) left in code that has shipped to a production system.

## Why it is dangerous

Breakpoints are a development and debugging tool. Surviving into production, they create real operational and security risk:

- **Availability.** A hit breakpoint halts the business transaction abruptly. Frozen or aborted processes affect system availability and can cause follow-on damage.
- **Authorization bypass.** A user with debug-change rights who lands on a breakpoint can inspect and alter variables — including the results of authorization checks — and so step around protections.
- **Data exposure.** The debugger exposes the full runtime state, including sensitive data in memory at that moment.
- **An unnecessary door.** Even unused, it is attack surface that should not exist in production. Best practice and BSI guidance are unambiguous: breakpoints belong in development and test only.

Overall rating: **Medium** (the availability and bypass impact can push individual cases higher).

## Detection

```
BREAK-POINT
BREAK
```

(The bare `BREAK <username>` form is just as relevant as `BREAK-POINT`.) Triage is usually trivial: in production, there is no legitimate hit.

## Remediation

Remove the breakpoint. Where diagnostics genuinely need to ship, use a **checkpoint group** (transaction `SAAB`) via `LOG-POINT` / `ASSERT ... ID <group>`. Checkpoint groups are **inactive by default** in production and can be switched on temporarily and per user without a transport:

```abap
LOG-POINT ID zbc_diag
  FIELDS sy-uname sy-datum sy-uzeit.
```

This ships safely (no effect unless activated) and never halts a transaction.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_BREAK.abap`](./ZBC_EVILDOER_BREAK.abap) | The anti-pattern (before) |
| [`ZBC_SECURE_BREAK.abap`](./ZBC_SECURE_BREAK.abap) | The remediated version (after) |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Remove all `BREAK-POINT` / `BREAK <user>` statements from productive code; convert the few legitimate diagnostics to checkpoint groups.
- **STAY_CLEAN:** This is a standard ABAP Test Cockpit check — enable it in the transport-release gate so a breakpoint can never reach production again.
