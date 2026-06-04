# ABAP_Evildoers
SAP ABAP Security Test Programs 

An important area of SAP security, which became focus in recent years, is the analysis of the customer-specific programs, which are classically written in the proprietary SAP language ABAP.
As in any programming language, classic vulnerabilities can be programmed – be it consciously or unconsciously, into existing code.
However, the patterns themselves are clearly different than in a Java stack or a Windows program. The aim of these conventional programs is usually to bring the program either crashed by targeted incorrect entries (buffer overflow) or artificially injected code for execution (code injection).

Both are not possible in an ABAP system as in other web systems like CGI-based servers, since a crash of a process does nothing else but create an entry in the log database (dump ST22) and exit the program by returning to the menu start point.

A direct manipulation as in other high-level languages ​​or servers is not possible in a classic attack scneario. However, there are other possibilities for manipulation.

More and more attack vectors on SAP systems have to deal with ABAP code that is used as a Trojan or that already poses a threat by itself. In one of my recent investigations with an SAP customer, I found an ABAP report in the production environment that completely cleared all FI tables (DROP Table Statements) without warning. With one stroke, his complete, worldwide bookkeeping would have been gone into nirvana, not recoverable.  Inadvertent execution would have had disastrous consequences. It turned out that this ABAP was used at the first launch in the 90s to reset the system in case of initial data loading. The ABAP was forgotten ever since and never deleted.

There are tools with which the customer-specific programs can be analyzed in a mass procedure. The results and findings will then have to be translated into a „get clean“ project and then into a „stay clean“ project. Here are in particular the Alchemist by xiting and the Code Vulnerability Analyzer of SAP to mention. Both of them had their Pro’s and Con’s, but they serve both this specific purpose.

The security scope of these projects can range from „just“ getting rid of old risks up to using continous „stay clean“ for large off-shore groups of  developers.

All these projects will not be „Big Bang“ projects,but rather a continous improvement of the current quality of the development organization. Therefore, it is mor a matter of education, enforcement and releasing of guidelines and policies. And, of course, continous mitigation of existing code.

The upcoming series of ABAP vulnerability blogs at my blog https://int.counterblog.org wants to devote itself in loose sequence to the patterns („Evildoer ABAPS“), their removal („GoodDoers“) and the associated tools.

We provide a series of EVILDOERS that contains pattern that will trigger any SAP alert for Code Violation and SAP Code Vulnerability Analysis. 

These patterns are dangerous, but circulate everywhere in the SAP world. If you are the customer or are responsible for the SAP Custom COde Security installation, feel free to use these patterns to check your system for security. 


**SAP ABAP security test programs — deliberately insecure code patterns for scanner calibration and secure-coding training.**

This repository collects the most common security anti-patterns found in custom (`Z*` / `Y*`) ABAP code, each as a minimal, recognizable example together with a clean, remediated counterpart. It is the companion code base to the German blog series *„SAP ABAP Code Security"* on [counterblog.org](https://www.counterblog.org).

## What this is for

Three legitimate, defensive purposes:

1. **Scanner calibration.** Validate that a custom-code scanner (e.g. a `RS_ABAP_SOURCE_SCAN` pattern set, ABAP Test Cockpit checks, or the SAP Code Vulnerability Analyzer) actually fires on the patterns it is supposed to catch — and does not fire on the clean versions. This is the SAP equivalent of the EICAR test file for antivirus.
2. **Secure-coding training.** Give developers a concrete "don't do this / do this instead" pair for each pattern, rather than an abstract guideline.
3. **GET_CLEAN / STAY_CLEAN reference.** A shared vocabulary of the patterns a remediation project needs to find and a quality gate needs to block.

## What this is **not**

This is **not** a collection of working exploits. The examples are written to be *recognizable to a scanner*, not to be *runnable as an attack*. Where a pattern's risk lies in chaining primitives into a functional payload (file drop + execute), this repository documents the **detection signature and the mitigation only** and deliberately does **not** ship a weaponized version. The goal is to help defenders find and remove these patterns, not to hand anyone a ready-made attack.

> ⚠️ **Use only in systems you own or are explicitly authorized to test.** These programs illustrate insecure constructs; running the insecure variants in a production system is irresponsible regardless of intent.

## Naming convention

| Prefix | Meaning |
| --- | --- |
| `ZBC_EVILDOER_*` | The insecure anti-pattern (the "before") |
| `ZBC_SECURE_*` | The remediated counterpart (the "after") |

## Pattern index

Each folder under `patterns/` contains a `README.md` (pattern, risk, detection, remediation) and the two ABAP programs.

| # | Folder | Pattern | Severity | Example type |
| --- | --- | --- | --- | --- |
| 01 | `sy-uname` | Hardcoded user comparison `IF sy-uname = '…'` | High | Full pair |
| 02 | `sy-mandt` | Hardcoded client comparison `IF sy-mandt = '…'` | Medium | Full pair |
| 03 | `break-point` | `BREAK-POINT` left in production code | Medium | Full pair |
| 04 | `hardcoded-url` | `CREATE_BY_URL` with a hardcoded external URL | Medium | Full pair |
| 05 | `hardcoded-password` | Credentials in clear text in source | High | Full pair |
| 06 | `bcode` | Reading the legacy `USR02-BCODE` password hash | High | Full pair |
| 07 | `call-system` | OS command execution via `CALL 'SYSTEM'` (deprecated) | High | Detection + remediation |
| 08 | `reposrc-write` | Writing to `REPOSRC` via Native SQL | Very high | Detection + remediation |

*"Full pair" = insecure + secure program. "Detection + remediation" = the recognizable token plus the fix, without a runnable attack chain.*

## Coding style

All examples are written in **classic ABAP** (compatible with NetWeaver 7.40 and later): no inline declarations, no string templates, no constructor expressions where a classic statement does the job. The point is portability across the wide range of releases these patterns actually live in, and reviewability by basis/security staff who do not write ABAP daily.

## License

See `LICENSE`. Educational/defensive use only.
