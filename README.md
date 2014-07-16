
------------------------

DDNS Wget Updater, 2013
===================

http://github.com/rohit-h/freedns-updater
twitter.com/@textbox37

------------------------

Bash scripts daemons to update domains provided by freedns.fraid.org

* This daemon can be run locally or via systemd.
* freednsctl.sh controls the daemon script, args = start|stop|status|restart.
* Example conf file provided under etc/freedns.conf.
* ~/.freednsrc will take precedence if run locally.
* usr/local/bin/freedns-mkconf.sh - sample script to help create initial .conf.
* Systemd service file provided under usr/lib/systemd/system/freedns.service.


Dependencies
------------------------
* wget (GNU Wget)
* dig  (from dnsutils package)
* systemd (optional)


Installation
------------------------
Copy files into appropriate destination directories. In case you wish to place them under different directories, be sure to modify hardcoded paths
