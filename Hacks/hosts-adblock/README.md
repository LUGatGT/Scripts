This script pulls a list of hosts files that block ads, combines them into one,
and then appends them to your /etc/hosts for system wide ad-blocking. Based on
adaway.

USAGE:
1. `mkdir -p /etc/adblock`
2. `cp /etc/hosts /etc/adblock/hosts`
3. `cp adblock.cron /etc/cron.daily/adblock`
4. `chmod +x /etc/cron.daily/adblock`
5. Restart your cron service.

CONFIGURATION:
1. Add extra host files to the top of adblock.cron.
2. If you want to make manual changes to your hosts file, add them to
   /etc/adblock/hosts.
