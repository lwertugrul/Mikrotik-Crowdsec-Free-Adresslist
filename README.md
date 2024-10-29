[![Cloudflare IP Updater](https://github.com/ertugrulturan/Mikrotik-Crowdsec-Free-Adresslist/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/ertugrulturan/Mikrotik-Crowdsec-Free-Adresslist/actions/workflows/main.yml)
Use (You can add it as a Scheduler),
```
/tool fetch url="https://raw.githubusercontent.com/ertugrulturan/Mikrotik-Crowdsec-Free-Adresslist/refs/heads/main/Crowdsec_FreeBlacklist.rsc" ; /import file-name=Crowdsec_FreeBlacklist.rsc
```
Tested by RouterOS 7.13.5
