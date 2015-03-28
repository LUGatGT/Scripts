GTwifi Configuration Files
==========================

I figured it’d be convenient for us to share our network configuration files
so it wouldn’t be guess and check for anyone that’s new to linux or new to
Tech.

netctl
------

 1. Copy `netctl_wlp2s0-GTwifi` to the netctl configuration folder (/etc/netctl/
    on Arch Linux) and rename it to _interface_-GTwifi where _interface_ is your
    wireless interface. This should need root permissions.
 2. Change the identy and password fields in the WPAConfigSection to your GT
    username and password.
 3. Change the location of the cert if your certs are located in a different
    location.
 4. Set the config file's permissions to 600 and make sure the user and group
    are root.
