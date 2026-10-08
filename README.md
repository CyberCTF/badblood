# BadBlood

[BadBlood](https://github.com/davidprowe/BadBlood) by David Rowe ([Secframe](https://www.secframe.com/badblood/)):
PowerShell that fills an Active Directory domain with a realistic structure and thousands of
objects and permissions, different on every run. This repository runs it with
[Isoloom](https://www.isoloom.com): [`isoloom.yml`](isoloom.yml) describes the machine, and
[`provision/main.yml`](provision/main.yml) builds it from a controller: it promotes a new forest,
`badblood.local`, then runs upstream's [`Invoke-BadBlood.ps1`](BadBlood/Invoke-BadBlood.ps1),
unchanged, with `-NonInteractive` and its default sizes (2500 users, 500 groups, 100 computers).

| Machine | Name | Services |
| --- | --- | --- |
| dc01 | domain controller of badblood.local (Windows Server 2019) | DNS 53, Kerberos 88, RPC 135, LDAP 389, SMB 445, WinRM 5985 |

What BadBlood creates: a tiered OU structure, users, groups and computers spread across it,
random group nesting, random ACLs on OUs and objects, random SPNs, and the LAPS schema extension
(with the LAPS files upstream ships).

BadBlood needs Domain Admin and Schema Admin rights: the provisioning account (a domain
administrator after promotion) is added to Schema Admins before it runs.

## Run it

```bash
isoloom run vagrant
isoloom test vagrant
```

About 5 GB of memory (4 GB for the domain controller, 1 GB for the controller) and 35 minutes,
about 20 of them for BadBlood itself. The Windows Server 2019 box is an evaluation build downloaded by
Vagrant. Collect the domain with BloodHound to find the paths.

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

GPL-3.0, as BadBlood ([LICENSE](LICENSE)). `BadBlood/AD_LAPS_Install/` carries Microsoft's LAPS
installer and templates as upstream ships them, under Microsoft's own terms. This lab is
deliberately vulnerable: keep it isolated.
