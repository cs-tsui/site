---
layout: post
title: "Commonly Used Commands"
date: 2020-03-31 18:12:00 -0400
comments: true
categories:
- cheatsheet
- shell
- linux
---

Here's a short cheatsheet for some useful commands when working with Linux/Unix systems.


Get specific column using `cut`. Tab is the default delimiter in cut

```bash
cat content | cut -d 'delimiter' -f <field number>
```


Output specific column using `awk`

```bash
cat content | awk -F/ '{print $1}'
```


Base64 encode (-n for no newline)

```bash
echo -n 'admin:password' | base64
```


Create gzipped tar

```bash
tar -czvf archive.tgz file1 dir2
```


Extract gzipped tar

```bash
# Output dir has to exist
tar -xzvf archive.tgz -C targetdir
```

Listening ports
```bash
sudo netstat -plnt

# or

sudo lsof -i -P | grep -i 'listen'
```

Disk usage sorted by size
```bash
du -hs * | sort -h
```

Xargs to pass arguments from stdin

```
xargs brew install < list.txt
```

Heredoc Syntax to create multi-line file from command line

```bash
cat <<EOT > app-pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: my-app-ui
  labels:
    app: my-app
spec:
  containers:
    - name: nginx-server
      image: nginx
EOT
```


Working with Docker
```
# Remove stopped containers and all unused images
docker system prune -a

# Remove certain images 
docker images -a | grep "pattern" | awk '{print $3}' | xargs docker rmi


# Remove all images
docker rmi $(docker images -a -q)

```

Working with systemd

```
# List all services
systemctl list-units --type=service

# Restart
systemctl restart application.service

# Get logs by the service unit
journalctl -u nginx.service

# Get data from yesterday
journalctl --since yesterday

# Get data from specific timestamps
journalctl --since "2015-01-10" --until "2015-01-11 03:00"

# Get log data from previous boot
journalctl -b -1

```