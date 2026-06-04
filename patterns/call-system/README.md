# Pattern 07 — OS command execution via `CALL 'SYSTEM'`

> **Detection + remediation entry.** The example carries the recognizable token with a fixed, harmless command and is not driven by user input. The injection vector (sourcing the command from external input) is deliberately not demonstrated.

## The pattern

```abap
CALL 'SYSTEM' ID 'COMMAND' FIELD lv_cmd
              ID 'TAB'     FIELD lt_result[].
```

A deprecated SAP kernel call that runs an operating-system command from ABAP.

## Why it is dangerous

`CALL 'SYSTEM'` lets a program execute OS commands on the application server. Under the wrong conditions it can let an attacker run arbitrary commands or code on the host **without rights beyond those needed to start a report**. The real risk appears when the command string is built from external input (OS command injection): the same statement then runs whatever the attacker supplies.

This can compromise the integrity of both the SAP system and the underlying host — unauthorized code execution, data manipulation, privilege escalation. SAP has marked the call **deprecated** for custom reports.

Overall rating: **High**.

## Detection

```
CALL 'SYSTEM'
```

Every hit is a finding in custom code. Triage focuses on whether the command is built from input that an attacker can influence — those cases are critical.

## Remediation

Replace `CALL 'SYSTEM'` with the sanctioned function module **`SXPG_COMMAND_EXECUTE`**, and harden the platform:

- `SXPG_COMMAND_EXECUTE` runs only **predefined logical commands** maintained in transaction **SM69** — never a free-form OS string from user input.
- It is protected by authorization object **`S_LOG_COM`** and is logged.
- At the platform level, block the kernel call entirely via profile parameter **`rdisp/call_system`**. Where this is set, the deprecated call is no longer executable and the attacker must find another route (which proper authorizations should also close).

```abap
CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
  EXPORTING commandname = 'ZBC_LS'        " predefined in SM69
  TABLES    exec_protocol = lt_protocol
  EXCEPTIONS no_permission = 1 OTHERS = 7.
```

## Files

| File | Role |
| --- | --- |
| [`ZBC_EVILDOER_SYSCMD.abap`](./ZBC_EVILDOER_SYSCMD.abap) | Detection fixture (recognizable token, harmless, no input) |
| [`ZBC_SECURE_SYSCMD.abap`](./ZBC_SECURE_SYSCMD.abap) | Sanctioned replacement via SXPG |

## GET_CLEAN / STAY_CLEAN

- **GET_CLEAN:** Replace every `CALL 'SYSTEM'` with `SXPG_COMMAND_EXECUTE` + an SM69 command; set `rdisp/call_system` to block the kernel call.
- **STAY_CLEAN:** Token in the ATC transport gate; coding guidelines forbid `CALL 'SYSTEM'` outright; `S_LOG_COM` kept least-privilege.
