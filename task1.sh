#!/bin/bash
date
who
uptime
date>>/var/log/syslog
who >>/var/log/syslog
uptime>>/var/log/syslog
