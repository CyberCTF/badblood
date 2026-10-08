#!/bin/sh
# BadBlood ran on dc01: its tiered OU structure, the LAPS schema extension it installs, and
# thousands of users (the LDAP answer is capped at 1000 entries by the server).
set -eu
base="DC=badblood,DC=local"
q() { curl -sS --max-time 60 -u 'BADBLOOD\vagrant:vagrant' "ldap://dc01/$1"; }
q "OU=Tier%200,OU=Admin,$base?ou?base" | grep -q "OU=Tier 0,OU=Admin"
q "CN=Schema,CN=Configuration,$base?cn?one?(cn=ms-Mcs-AdmPwd)" | grep -q "ms-Mcs-AdmPwd"
users=$(q "$base?sAMAccountName?sub?(objectCategory=person)" | grep -c "^DN:" || true)
[ "$users" -ge 1000 ]
echo "BadBlood OUs, LAPS schema and $users+ users are in badblood.local"
