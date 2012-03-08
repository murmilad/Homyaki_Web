#!/bin/bash

(zcat /var/log/apache2/access.log*.gz 2>/dev/null; cat /var/log/apache2/access.log.1 2>/dev/null; cat /var/log/apache2/access.log 2>/dev/null) | awk '{print $1 $7}'|grep -P $1 | grep -oh -P '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | uniq | grep -c -P '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

