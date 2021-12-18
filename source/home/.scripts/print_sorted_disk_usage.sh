sudo du -ah / 1>/tmp/disk_usage.tmp
grep "^[0-9.]\+G" /tmp/disk_usage.tmp | sort -n -r
grep "^[0-9.]\+M" /tmp/disk_usage.tmp | sort -n -r
grep "^[0-9.]\+K" /tmp/disk_usage.tmp | sort -n -r
