Script get all MX record for domain and check them PTR record. And you can use another DNS server in 2th parameter of script

Example:
```
vint@postfix:~$ ./check_domain.sh telegram.org

Checking domain: telegram.org
The DNS server used is: 127.0.0.53

Resolved DNS names in:
        149.154.167.99
Looking for MX records
        mx10.telegram.org.
                95.161.64.10 ... check PTR record ... OK
        mx101.telegram.org.
                95.161.64.16 ... check PTR record ... OK
        mail.telegram.supply.
                95.161.64.2 ... check PTR record ...PTR record not found
```

or with another DNS server

```
vint@postfix:~$ ./check_domain.sh telegram.org 8.8.8.8

Checking domain: telegram.org
The DNS server used is: 8.8.8.8

Resolved DNS names in:
        149.154.167.99
Looking for MX records
        mx101.telegram.org.
                95.161.64.16 ... check PTR record ... OK
        mx10.telegram.org.
                95.161.64.10 ... check PTR record ... OK
        mail.telegram.supply.
                95.161.64.2 ... check PTR record ...PTR record not found
```

Warning, this script fails for MXs associated with major mail services like Google etc. But Postfix does not throw an error for these mail servers.
