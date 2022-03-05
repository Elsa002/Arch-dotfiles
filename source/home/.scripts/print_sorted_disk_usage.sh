echo "" > /tmp/disk_usage.tmp
sudo du -ah /bin 1>>/tmp/disk_usage.tmp
sudo du -ah /etc 1>>/tmp/disk_usage.tmp
sudo du -ah /lib 1>>/tmp/disk_usage.tmp
sudo du -ah /opt 1>>/tmp/disk_usage.tmp
sudo du -ah /usr 1>>/tmp/disk_usage.tmp
sudo du -ah /home 1>>/tmp/disk_usage.tmp
sudo du -ah /root 1>>/tmp/disk_usage.tmp
sudo du -ah /boot 1>>/tmp/disk_usage.tmp
grep "^[0-9.]\+G" /tmp/disk_usage.tmp | sort -n -r
grep "^[0-9.]\+M" /tmp/disk_usage.tmp | sort -n -r
grep "^[0-9.]\+K" /tmp/disk_usage.tmp | sort -n -r
