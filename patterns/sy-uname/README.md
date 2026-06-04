# Pattern 01 — Hardcoded user comparison (`IF sy-uname = '…'`)

## The pattern

Custom code restricts a function to specific people by comparing the current user against a literal user ID:

```abap
IF sy-uname = 'DEVELOPER1'.
  PERFORM critical_action.
ENDIF.
```

It looks simple and pragmatic. It is neither secure nor maintainable.

## Why it is dangerous

A hardcoded user comparison **bypasses the SAP authorization concept entirely**. The consequences:

- **Not auditable.** The decision does not appear in any standard authorization trace. SU53, role analysis and the security audit log are blind to it.
- **Not scalable.** Granting access to a second person means a code change and a transport — not a role assignment.
- **Fragile under change.** If the account is renamed, copied to a colleague, mis-assigned or compromised, the protected logic runs with no legitimate check behind it.
- **Invisible in reviews.** Because it never shows up in standard authorization checks, it tends to survive audits unnoticed.

The likelihood is raised by everyday events (account misconfiguration, password compromise); the impact can be severe, because the protected action is usually one that should be reserved for a narrowly authorized role. Overall rating: **High**.

## Detection

Pattern scan for the source tokens (case-insensitive, ABAP allows both `=` and `EQ`):

```
sy-uname =
sy-uname EQ
```

Then triage manually: a comparison used purely for logging or display is harmless; a comparison that *guards an action or a branch* is the finding. The ABAP Test Cockpit ships related checks; for `RS_ABAP_SOURCE_SCAN` add the tokens above to the pattern set.

## Remediation

Replace the literal comparison with an `AUTHORITY-CHECK` against a custom authorization object:

```abap
AUTHORITY-CHECK OBJECT 'Z_CRIT_ACT'
  ID 'ACTVT' FIELD '16'.
IF sy-subrc <> 0.
  MESSAGE 'No authorization for this action.' TYPE 'E'.
ENDIF.
```

Create the authorization object in **SU21** (here `Z_CRIT_ACT` with field `ACTVT`), add it to the relevant role, and assign the role. The check is now role-based, auditable and centrally governed — and **fails closed**: no authorization means no execution.

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_UNAME.abap`](./ZBC_EVILDOER_UNAME.abap) | The anti-pattern (before) |
| [`ZBC_SECURE_UNAME.abap`](./ZBC_SECURE_UNAME.abap) | The remediated version (after) |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Find all guarding `sy-uname` comparisons, replace each with an authorization object, retire the now-dead literals.
- **STAY_CLEAN:** Add the tokens to the transport-release ATC variant so new occurrences are blocked before they ship. Document the rule in the coding guidelines.
