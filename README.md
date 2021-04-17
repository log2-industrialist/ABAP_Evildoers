# ABAP Evildoers
SAP ABAP Security Test Programs 

An important area of SAP security, which became focus in recent years, is the analysis of the customer-specific programs, which are classically written in the proprietary SAP language ABAP.
As in any programming language, classic vulnerabilities can be programmed – be it consciously or unconsciously, into existing code.
However, the patterns themselves are clearly different than in a Java stack or a Windows program. The aim of these conventional programs is usually to bring the program either crashed by targeted incorrect entries (buffer overflow) or artificially injected code for execution (code injection).

Both are not possible in an ABAP system as in other web systems like CGI-based servers, since a crash of a process does nothing else but create an entry in the log database (dump ST22) and exit the program by returning to the menu start point.

A direct manipulation as in other high-level languages ​​or servers is not possible in a classic attack scneario. However, there are other possibilities for manipulation.

More and more attack vectors on SAP systems have to deal with ABAP code that is used as a Trojan or that already poses a threat by itself. In one of my recent investigations with an SAP customer, I found an ABAP report in the production environment that completely cleared all FI tables (DROP Table Statements) without warning. With one stroke, his complete, worldwide bookkeeping would have been gone into nirvana, not recoverable.  Inadvertent execution would have had disastrous consequences. It turned out that this ABAP was used at the first launch in the 90s to reset the system in case of initial data loading. The ABAP was forgotten ever since and never deleted.

There are tools with which the customer-specific programs can be analyzed in a mass procedure. The results and findings will then have to be translated into a „get clean“ project and then into a „stay clean“ project. Here are in particular the CodeProfiler of Virtual Forge and the Code Vulnerability Analyzer of SAP to mention. Both of them had their Pro’s and Con’s, but they server both this specific purpose.

The security scope of these projects can range from „just“ getting rid of old risks up to using continous „stay clean“ for large off-shore groups of  developers.

All these projects will not be „Big Bang“ projects,but rather a continous improvement of the current quality of the development organization. Therefore, it is mor a matter of education, enforcement and releasing of guidelines and policies. And, of course, continous mitigation of existing code.

The upcoming series of ABAP vulnerability blogs at my blog https://int.counterblog.org wants to devote itself in loose sequence to the patterns („Evildoer ABAPS“), their removal („GoodDoers“) and the associated tools.

We provide a series of EVILDOERS that contains pattern that will trigger any SAP alert for Code Violation and SAP Code Vulnerability Analysis. 

These patterns are dangerous, but circulate everywhere in the SAP world. If you are the customer or are responsible for the SAP Custom COde Security installation, feel free to use these patterns to check your system for security. 
